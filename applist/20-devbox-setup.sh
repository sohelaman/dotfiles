#!/usr/bin/env bash
# =============================================================================
# devbox-setup.sh — Debian 13 (trixie) distrobox development environment bootstrap
# -----------------------------------------------------------------------------
# Usage (run as your normal user INSIDE the container; uses sudo as needed):
#
#   distrobox create --name devbox --image docker.io/library/debian:trixie
#   distrobox enter devbox
#   bash devbox-setup.sh
#
# Optional toggles (environment variables):
#   PHP_VERSIONS="8.5 8.4 ... 5.6" PHP versions (default: every release 5.6 → 8.5; "84" also works)
#   DEFAULT_PHP=8.4                Version behind the plain `php` command
#   DEFAULT_JDK=25                 8 | 21 | 25
#   NODE_MAJOR=24                  NodeSource major version; "debian" uses trixie's own nodejs (20)
#   ENABLE_NONFREE=yes             Needed for `unrar` (non-free); "no" uses `unar`
#   INSTALL_ORACLE=yes             Oracle Instant Client + oci8 (accepts Oracle licence)
#   INSTALL_MSSQL=yes              MS ODBC 18 + sqlcmd + sqlsrv (accepts Microsoft EULA)
#   INSTALL_XDEBUG=yes             Xdebug for every PHP version
#   DEBIAN_MIRROR=http://deb.debian.org/debian   e.g. a local mirror
#
#   e.g.  INSTALL_MSSQL=no PHP_VERSIONS="8.4 8.3" bash devbox-setup.sh
#
# Helpers installed:  php-use <5.6|7.0|...|8.5>     jdk-use <8|21|25>
# The script is idempotent: safe to re-run. Failures are reported, not fatal.
# =============================================================================
set -Eeuo pipefail

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  sed -n '2,27p' "$0"; exit 0
fi

# ----------------------------- Configuration ---------------------------------
norm_php() { local v="${1//./}"; echo "${v:0:1}.${v:1}"; }   # 84 | 8.4 -> 8.4
read -r -a _pv <<< "${PHP_VERSIONS:-8.5 8.4 8.3 8.2 8.1 8.0 7.4 7.3 7.2 7.1 7.0 5.6}"
PHP_VERSIONS=(); for _v in "${_pv[@]}"; do PHP_VERSIONS+=("$(norm_php "$_v")"); done
DEFAULT_PHP="$(norm_php "${DEFAULT_PHP:-8.4}")"
DEFAULT_JDK="${DEFAULT_JDK:-25}"
NODE_MAJOR="${NODE_MAJOR:-24}"
ENABLE_NONFREE="${ENABLE_NONFREE:-yes}"
INSTALL_ORACLE="${INSTALL_ORACLE:-yes}"
INSTALL_MSSQL="${INSTALL_MSSQL:-yes}"
INSTALL_XDEBUG="${INSTALL_XDEBUG:-yes}"
DEBIAN_MIRROR="${DEBIAN_MIRROR:-http://deb.debian.org/debian}"

STAMP="$(date +%Y%m%d-%H%M%S)"
LOG_FILE="${LOG_FILE:-/tmp/devbox-setup-${STAMP}.log}"
MISSING_FILE="/tmp/devbox-setup-${STAMP}.missing"
FAILED_FILE="/tmp/devbox-setup-${STAMP}.failed"
: > "$MISSING_FILE"; : > "$FAILED_FILE"

if [[ $EUID -eq 0 ]]; then SUDO=(); else SUDO=(sudo); fi
APT=( "${SUDO[@]}" env DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get -y -q
      --no-install-recommends -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold )
KEYRINGS=/etc/apt/keyrings
# Old PHP/PECL sources predate GCC 14, which made these warnings hard errors.
PECL_CFLAGS="-O2 -Wno-error=implicit-function-declaration -Wno-error=incompatible-pointer-types -Wno-error=int-conversion"

exec > >(tee -a "$LOG_FILE") 2>&1

# ------------------------------- Helpers -------------------------------------
log()  { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
info() { printf '    %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31m[ERR ]\033[0m %s\n' "$*"; }
trap 'err "line ${LINENO}: ${BASH_COMMAND}"' ERR

have_pkg() { [[ "$(dpkg-query -W -f='${Status}' "$1" 2>/dev/null)" == "install ok installed" ]]; }
pkg_available() {
  local c
  c="$(apt-cache policy "$1" 2>/dev/null | awk '/Candidate:/ {print $2}')"
  [[ -n "$c" && "$c" != "(none)" ]]
}
# pick <pkg> [alt...]  -> first package name that exists (falls back to the first)
pick() {
  local p
  for p in "$@"; do pkg_available "$p" && { echo "$p"; return 0; }; done
  echo "$1"
}
# apt_install <pkg...>  -> installs what exists; apt is all-or-nothing, so retry one by one on failure
apt_install() {
  local p; local -a ok=()
  for p in "$@"; do pkg_available "$p" && ok+=("$p"); done
  (( ${#ok[@]} )) || return 0
  "${APT[@]}" install "${ok[@]}" && return 0
  warn "Batch install failed — retrying packages individually"
  for p in "${ok[@]}"; do "${APT[@]}" install "$p" || true; done
  return 1
}
# install_group <label> <pkg...>  -> installs, records anything that did not land
install_group() {
  local label="$1"; shift
  log "$label"
  apt_install "$@" || warn "apt reported errors for: $label"
  local p
  for p in "$@"; do have_pkg "$p" || echo "$label -> $p" >> "$MISSING_FILE"; done
}
# fetch <url> <dest>  -> download over HTTPS to a root-owned path
fetch() { curl -fsSL --proto '=https' --tlsv1.2 "$1" | "${SUDO[@]}" tee "$2" >/dev/null; }
write_file() {  # write_file <path> <content>
  printf '%s\n' "$2" | "${SUDO[@]}" tee "$1" >/dev/null
}
# run_step <name> <function> — runs in a subshell with errexit; never aborts the script
run_step() {
  local name="$1"; shift
  log "STEP: $name"
  set +e
  ( set -e; "$@" )
  local rc=$?
  set -e
  if (( rc != 0 )); then
    echo "$name (rc=$rc)" >> "$FAILED_FILE"
    err "Step '$name' failed — continuing"
  fi
}
php_bin() {  # php_bin <ver> -> path to that PHP binary, or empty
  [[ -x "/usr/bin/php$1" ]] && echo "/usr/bin/php$1"
  return 0
}

# ------------------------------- Preflight -----------------------------------
preflight() {
  log "Preflight"
  grep -q '^ID=debian' /etc/os-release || { err "This script targets Debian."; exit 1; }
  local codename; codename="$(. /etc/os-release; echo "${VERSION_CODENAME:-}")"
  [[ "$codename" == "trixie" ]] || warn "Expected Debian trixie, found '$codename' — continuing anyway."
  [[ -f /run/.containerenv || -n "${CONTAINER_ID:-}" ]] \
    || warn "Not running inside a container — this script is intended for distrobox."
  (( ${#SUDO[@]} == 0 )) || sudo -v
  info "Log file: $LOG_FILE"
}

# ------------------------------- Repositories --------------------------------
setup_debian_sources() {
  local comps="main"
  [[ "$ENABLE_NONFREE" == "yes" ]] && comps="main contrib non-free non-free-firmware"
  log "Debian sources: $DEBIAN_MIRROR ($comps) + backports"
  write_file /etc/apt/sources.list.d/debian.sources "# Managed by devbox-setup.sh
Types: deb
URIs: $DEBIAN_MIRROR
Suites: trixie trixie-updates trixie-backports
Components: $comps
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: http://security.debian.org/debian-security
Suites: trixie-security
Components: $comps
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg"
  "${SUDO[@]}" rm -f /etc/apt/sources.list   # older images; everything is in debian.sources now
  # Parallel downloads from the same host (apt defaults to a single connection per host).
  write_file /etc/apt/apt.conf.d/90devbox 'Acquire::Queue-Mode "access";
Acquire::Retries "3";'
}

# Third-party repos are pinned so they can only supply the packages we want from them.
# The allow record comes first: apt uses the first matching specific pin.
pin_origin() {  # pin_origin <name> <host> <package globs>
  write_file "/etc/apt/preferences.d/$1" "# Managed by devbox-setup.sh
Package: $3
Pin: origin $2
Pin-Priority: 500

Package: *
Pin: origin $2
Pin-Priority: -1"
}

setup_repos() {
  "${SUDO[@]}" install -d -m 0755 "$KEYRINGS"

  # Sury: the de-facto source of every PHP version for Debian. Not pinned: it also ships the
  # library builds those PHP packages are linked against.
  if [[ ! -f /usr/share/keyrings/debsuryorg-archive-keyring.gpg ]]; then
    log "Adding Sury PHP repository"
    local tmp; tmp="$(mktemp -d)"
    curl -fsSL --proto '=https' https://packages.sury.org/debsuryorg-archive-keyring.deb -o "$tmp/sury.deb"
    "${SUDO[@]}" dpkg -i "$tmp/sury.deb"
    rm -rf "$tmp"
  fi
  write_file /etc/apt/sources.list.d/php-sury.sources 'Types: deb
URIs: https://packages.sury.org/php/
Suites: trixie
Components: main
Signed-By: /usr/share/keyrings/debsuryorg-archive-keyring.gpg'

  log "Adding Eclipse Adoptium (Temurin) repository (scoped to temurin-*, adoptium-*)"
  fetch https://packages.adoptium.net/artifactory/api/gpg/key/public "$KEYRINGS/adoptium.asc"
  write_file /etc/apt/sources.list.d/adoptium.sources "Types: deb
URIs: https://packages.adoptium.net/artifactory/deb
Suites: trixie
Components: main
Signed-By: $KEYRINGS/adoptium.asc"
  pin_origin adoptium packages.adoptium.net 'temurin-* adoptium-*'

  if [[ "$NODE_MAJOR" != "debian" ]]; then
    log "Adding NodeSource repository for Node $NODE_MAJOR (scoped to nodejs)"
    fetch https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key "$KEYRINGS/nodesource.asc"
    write_file /etc/apt/sources.list.d/nodesource.sources "Types: deb
URIs: https://deb.nodesource.com/node_${NODE_MAJOR}.x
Suites: nodistro
Components: main
Signed-By: $KEYRINGS/nodesource.asc"
    pin_origin nodesource deb.nodesource.com 'nodejs'
  else
    "${SUDO[@]}" rm -f /etc/apt/sources.list.d/nodesource.sources /etc/apt/preferences.d/nodesource
  fi

  # Microsoft: .NET SDKs always; ODBC driver + sqlcmd only with INSTALL_MSSQL.
  log "Adding Microsoft repository (scoped to .NET + ODBC driver + sqlcmd)"
  # The Debian 13 repo is signed with Microsoft's 2025 key, not the older microsoft.asc.
  fetch https://packages.microsoft.com/keys/microsoft-2025.asc "$KEYRINGS/microsoft.asc"
  write_file /etc/apt/sources.list.d/microsoft-prod.sources "Types: deb
URIs: https://packages.microsoft.com/debian/13/prod
Suites: trixie
Components: main
Signed-By: $KEYRINGS/microsoft.asc"
  pin_origin microsoft packages.microsoft.com \
    'dotnet-* aspnetcore-* netstandard-* msodbcsql18 mssql-tools18'

  # apt still refreshes the healthy repos when one fails; report it instead of aborting.
  "${APT[@]}" update || warn "apt update reported errors — a repository may be unreachable or mis-signed"
}

step_base() {
  setup_debian_sources
  "${APT[@]}" update
  apt_install ca-certificates curl gnupg jq unzip debian-archive-keyring apt-utils
  setup_repos
  "${APT[@]}" full-upgrade || warn "System upgrade reported errors"
}

# ------------------------------- Tool groups ---------------------------------
# Debian renames a few binaries; provide the familiar names.
alias_bin() {  # alias_bin <debian-name> <usual-name>
  if command -v "$1" >/dev/null 2>&1 && ! command -v "$2" >/dev/null 2>&1; then
    "${SUDO[@]}" ln -sf "$(command -v "$1")" "/usr/local/bin/$2"
  fi
}

step_common() {
  local rar=unar
  if [[ "$ENABLE_NONFREE" == "yes" ]]; then rar=unrar; fi
  install_group "1. Common tools" \
    vim tmux fish wget git git-lfs "$rar" 7zip zip unzip tar gzip bzip2 xz-utils zstd
}

step_useful() {
  install_group "2. Useful tools" \
    busybox entr time vifm pass pinentry-curses jq bat eza fzf ripgrep ncdu httpie openssl \
    fd-find tree zoxide git-delta tig gh yq shellcheck direnv tealdeer rsync lsof strace \
    less man-db manpages bash-completion file diffutils patch procps passwd
  alias_bin batcat bat
  alias_bin fdfind fd
}

step_monitoring() {
  install_group "3. Monitoring tools" htop btop nvtop bmon nethogs iotop-c sysstat
}

step_network() {
  install_group "4. Networking tools" \
    iputils-ping telnet traceroute bind9-dnsutils netcat-openbsd curl \
    mtr-tiny whois socat tcpdump iproute2 net-tools openssh-client nmap
}

step_build() {
  install_group "5. Development & build tools" \
    build-essential cmake autoconf automake libtool pkgconf ninja-build gdb \
    libssl-dev zlib1g-dev libffi-dev libreadline-dev
}

# Oracle ships Instant Client as signed RPMs only; verify the signature, then convert with alien.
# Taken from the OL9 repo: the standalone downloads are signed with Oracle's OL8 key, whose
# SHA-1 self-signature Debian's rpm (Sequoia) rejects.
install_instantclient() {
  local repo=https://yum.oracle.com/repo/OracleLinux/OL9/oracle/instantclient23/x86_64
  local tmp f p primary href
  if have_pkg oracle-instantclient-basic; then info "Oracle Instant Client already installed"; return 0; fi
  log "Oracle Instant Client (RPM signature verified, converted with alien)"
  apt_install alien rpm libaio1t64
  tmp="$(mktemp -d)"
  curl -fsSL --proto '=https' https://yum.oracle.com/RPM-GPG-KEY-oracle-ol9 -o "$tmp/oracle.key"
  rpmkeys --dbpath "$tmp/rpmdb" --import "$tmp/oracle.key"
  primary="$(curl -fsSL --proto '=https' "$repo/repodata/repomd.xml" | grep -oE 'repodata/[^"]*primary\.xml\.gz' | head -n 1)"
  curl -fsSL --proto '=https' "$repo/$primary" | gunzip > "$tmp/primary.xml"
  for p in basic devel sqlplus; do
    href="$(grep -oE "href=\"getPackage/oracle-instantclient-$p-[0-9][^\"]*\.x86_64\.rpm\"" "$tmp/primary.xml" \
            | cut -d'"' -f2 | sort -V | tail -n 1)"
    [[ -n "$href" ]] || { err "oracle-instantclient-$p not found in $repo"; rm -rf "$tmp"; return 1; }
    f="$tmp/oracle-instantclient-$p.rpm"
    curl -fsSL --proto '=https' "$repo/$href" -o "$f"
    rpmkeys --dbpath "$tmp/rpmdb" --checksig "$f" | grep -q 'digests signatures OK' \
      || { err "Signature check failed for $f"; rm -rf "$tmp"; return 1; }
  done
  ( cd "$tmp" && "${SUDO[@]}" alien --to-deb oracle-instantclient-*.rpm >/dev/null )
  "${SUDO[@]}" env DEBIAN_FRONTEND=noninteractive dpkg -i "$tmp"/oracle-instantclient*.deb
  # Debian renamed libaio.so.1 (t64 transition); Instant Client still asks for the old name.
  if [[ ! -e /usr/lib/x86_64-linux-gnu/libaio.so.1 && -e /usr/lib/x86_64-linux-gnu/libaio.so.1t64 ]]; then
    "${SUDO[@]}" ln -s libaio.so.1t64 /usr/lib/x86_64-linux-gnu/libaio.so.1
  fi
  local lib; lib="$(ls -d /usr/lib/oracle/*/client64/lib 2>/dev/null | sort -V | tail -n 1)"
  [[ -n "$lib" ]] && write_file /etc/ld.so.conf.d/oracle-instantclient.conf "$lib"
  "${SUDO[@]}" ldconfig
  rm -rf "$tmp"
}

step_db_clients() {
  install_group "16. Database clients (no servers enabled)" \
    default-mysql-client postgresql-client "$(pick redis-tools valkey-tools)" sqlite3 unixodbc
  alias_bin valkey-cli redis-cli

  if [[ "$INSTALL_ORACLE" == "yes" ]]; then
    install_instantclient || echo "Oracle -> Instant Client" >> "$MISSING_FILE"
  fi

  if [[ "$INSTALL_MSSQL" == "yes" ]]; then
    install_group "Microsoft ODBC Driver 18 + sqlcmd (needed by sqlsrv) — ACCEPT_EULA=Y" \
      msodbcsql18 mssql-tools18 unixodbc-dev
  fi
}

# pecl release that still supports a given PHP version ("" = not available for it)
sqlsrv_for() {
  case "$1" in
    5.6) echo "" ;;
    7.0) echo "5.3.0" ;;  7.1) echo "5.6.1" ;;  7.2) echo "5.8.1" ;;  7.3) echo "5.9.0" ;;
    7.4) echo "5.10.1" ;; 8.0) echo "5.11.1" ;; 8.1) echo "5.12.0" ;;
    *)   echo "latest" ;;
  esac
}
oci8_for() {
  case "$1" in
    5.6) echo "2.0.12" ;;
    7.*) echo "2.2.0" ;;
    8.0) echo "3.0.1" ;;
    8.1) echo "3.2.1" ;;
    8.2|8.3) echo "3.3.0" ;;
    *)   echo "latest" ;;
  esac
}

# ext_build <php-ver> <ext> <pecl-version|latest> [configure args...]
# Builds a PECL tarball against that version's phpize/php-config in a fresh directory and
# enables it via phpenmod. Avoids the pecl tool: its temp dir and registry are shared by all
# versions, and its "already loaded" check runs against the default php, not the target.
# -I shared/: old sqlsrv config.m4 fails to add it under autoconf 2.72.
# EXT_CPPFLAGS (env) adds include paths, e.g. the Instant Client SDK for oci8 2.x.
ext_build() {
  local v="$1" ext="$2" rel="$3"; shift 3
  local url="https://pecl.php.net/get/$ext" tmp src
  [[ "$rel" != "latest" ]] && url+="-$rel"
  if "/usr/bin/php$v" -m 2>/dev/null | grep -qix "$ext"; then info "PHP $v: $ext already enabled"; return 0; fi
  [[ -x "/usr/bin/phpize$v" ]] || { err "phpize$v missing (php$v-dev)"; return 1; }
  log "PHP $v: building $ext ${rel}"
  tmp="$(mktemp -d)"
  curl -fsSL --proto '=https' "$url" | tar -xz -C "$tmp" || { rm -rf "$tmp"; return 1; }
  src="$(find "$tmp" -mindepth 1 -maxdepth 1 -type d -name "$ext-*" | head -n 1)"
  [[ -n "$src" ]] || { rm -rf "$tmp"; return 1; }
  ( cd "$src" \
    && "/usr/bin/phpize$v" >/dev/null \
    && CPPFLAGS="${EXT_CPPFLAGS:-}" CFLAGS="$PECL_CFLAGS" CXXFLAGS="-O2 -I$src/shared" ./configure -q --with-php-config="/usr/bin/php-config$v" "$@" \
    && make -s -j"$(nproc)" >/dev/null \
    && "${SUDO[@]}" make -s install ) || { rm -rf "$tmp"; return 1; }
  rm -rf "$tmp"
  write_file "/etc/php/$v/mods-available/$ext.ini" "; priority=30
extension=$ext.so"
  "${SUDO[@]}" phpenmod -v "$v" -s ALL "$ext"
}

step_php() {
  local v e rel lib inc
  local -a pkgs
  for v in "${PHP_VERSIONS[@]}"; do
    log "6. PHP $v"
    if ! pkg_available "php$v-cli"; then
      warn "No packages for PHP $v in the Sury repository — skipped"
      echo "PHP -> php$v (not in repository)" >> "$MISSING_FILE"
      continue
    fi
    pkgs=()
    for e in cli common dev mysql pgsql sqlite3 opcache mbstring xml gd intl bcmath soap ldap \
             zip curl readline redis igbinary json; do
      pkgs+=("php$v-$e")
    done
    if [[ "$INSTALL_XDEBUG" == "yes" ]]; then pkgs+=("php$v-xdebug"); fi
    # Not every extension is a separate package for every version (json/opcache are built in
    # on newer ones); apt_install only takes the ones that exist.
    apt_install "${pkgs[@]}" || warn "PHP $v install reported errors"
    [[ -n "$(php_bin "$v")" ]] || { echo "PHP -> php$v (binary not found)" >> "$MISSING_FILE"; continue; }

    if [[ "$INSTALL_MSSQL" == "yes" ]]; then
      rel="$(sqlsrv_for "$v")"
      if [[ -n "$rel" ]]; then
        ext_build "$v" sqlsrv "$rel"     || echo "PHP $v -> sqlsrv (build failed)" >> "$MISSING_FILE"
        ext_build "$v" pdo_sqlsrv "$rel" || echo "PHP $v -> pdo_sqlsrv (build failed)" >> "$MISSING_FILE"
      fi
    fi
    if [[ "$INSTALL_ORACLE" == "yes" ]]; then
      lib="$(ls -d /usr/lib/oracle/*/client64/lib 2>/dev/null | sort -V | tail -n 1 || true)"
      inc="$(ls -d /usr/include/oracle/*/client64 2>/dev/null | sort -V | tail -n 1 || true)"
      if [[ -n "$lib" ]]; then
        EXT_CPPFLAGS="${inc:+-I$inc}" ext_build "$v" oci8 "$(oci8_for "$v")" --with-oci8="instantclient,$lib" \
          || echo "PHP $v -> oci8 (build failed)" >> "$MISSING_FILE"
      fi
    fi
  done

  local t
  for t in php phpize php-config; do
    if [[ -x "/usr/bin/$t$DEFAULT_PHP" ]]; then
      "${SUDO[@]}" update-alternatives --set "$t" "/usr/bin/$t$DEFAULT_PHP" >/dev/null || true
    fi
  done
  if [[ -x "/usr/bin/php$DEFAULT_PHP" ]]; then
    info "Default php -> /usr/bin/php$DEFAULT_PHP"
  else
    warn "DEFAULT_PHP=$DEFAULT_PHP not installed; alternatives left on auto"
  fi
}

step_composer() {
  local php tmp expected actual b
  php="$(php_bin "$DEFAULT_PHP")"
  [[ -n "$php" ]] || php="$(php_bin 8.4)"
  [[ -n "$php" ]] || php="$(php_bin 8.5)"
  [[ -n "$php" ]] || { err "No PHP >= 8.2 available for Composer tooling"; return 1; }

  if [[ ! -x /usr/local/bin/composer ]]; then
    log "Composer (installer signature verified)"
    tmp="$(mktemp -d)"
    expected="$(curl -fsSL https://composer.github.io/installer.sig)"
    curl -fsSL https://getcomposer.org/installer -o "$tmp/composer-setup.php"
    actual="$("$php" -r "echo hash_file('sha384', '$tmp/composer-setup.php');")"
    if [[ "$expected" != "$actual" ]]; then
      rm -rf "$tmp"; err "Composer installer checksum mismatch — aborting Composer install"; return 1
    fi
    "${SUDO[@]}" "$php" "$tmp/composer-setup.php" --quiet --install-dir=/usr/local/bin --filename=composer
    rm -rf "$tmp"
  else
    "${SUDO[@]}" "$php" /usr/local/bin/composer self-update --quiet || warn "composer self-update failed"
  fi

  # Global tools live in a system COMPOSER_HOME so the shared distrobox $HOME stays clean.
  log "PHPStan + Laravel installer"
  "${SUDO[@]}" env COMPOSER_HOME=/usr/local/share/composer COMPOSER_ALLOW_SUPERUSER=1 \
    "$php" /usr/local/bin/composer global require --no-interaction --quiet phpstan/phpstan laravel/installer
  for b in phpstan laravel; do
    "${SUDO[@]}" ln -sf "/usr/local/share/composer/vendor/bin/$b" "/usr/local/bin/$b"
  done
}

step_node() {
  if [[ "$NODE_MAJOR" == "debian" ]]; then
    install_group "7. Node.js (Debian)" nodejs npm
  else
    install_group "7. Node.js $NODE_MAJOR (NodeSource, includes npm)" nodejs
  fi
  log "8. Yarn + bundlers (npm global, /usr/local)"
  "${SUDO[@]}" /usr/bin/npm install -g --prefix /usr/local --no-fund --loglevel=error \
    yarn pnpm typescript gulp-cli grunt-cli webpack webpack-cli parcel
}

step_lua() {
  install_group "9. Lua" lua5.4 liblua5.4-dev luarocks
  # luarocks pulls in lua5.1, which would otherwise win the `lua` alternative
  "${SUDO[@]}" update-alternatives --set lua-interpreter /usr/bin/lua5.4 >/dev/null || true
  "${SUDO[@]}" update-alternatives --set lua-compiler /usr/bin/luac5.4 >/dev/null || true
}
step_go() {
  log "10. Go (trixie-backports)"
  "${APT[@]}" install -t trixie-backports golang-go || warn "apt reported errors for: Go"
  have_pkg golang-go || echo "10. Go -> golang-go" >> "$MISSING_FILE"
}
step_ruby()   { install_group "11. Ruby"   ruby ruby-dev ruby-bundler rake; }
step_prolog() { install_group "12. Prolog" swi-prolog-nox; }
step_rust()   { install_group "Extra: Rust" rustc cargo rustfmt rust-clippy; }

step_python() {
  install_group "13. Python" python3 python3-pip python3-venv python3-virtualenv python3-dev pipx
  # uv isn't packaged for trixie; a global pipx install keeps it out of the shared $HOME.
  if ! command -v uv >/dev/null 2>&1; then
    log "uv (pipx --global: /opt/pipx, /usr/local/bin)"
    "${SUDO[@]}" pipx install --global uv || echo "13. Python -> uv" >> "$MISSING_FILE"
  fi
}

install_gradle() {
  local meta ver url sumurl tmp
  log "Gradle (latest, SHA-256 verified)"
  meta="$(curl -fsSL https://services.gradle.org/versions/current)"
  ver="$(jq -r .version <<< "$meta")"
  url="$(jq -r .downloadUrl <<< "$meta")"
  sumurl="$(jq -r .checksumUrl <<< "$meta")"
  if [[ -x "/opt/gradle/gradle-${ver}/bin/gradle" ]]; then
    info "Gradle $ver already installed"
  else
    tmp="$(mktemp -d)"
    curl -fsSL "$url" -o "$tmp/gradle.zip"
    echo "$(curl -fsSL "$sumurl")  $tmp/gradle.zip" | sha256sum -c --quiet -
    "${SUDO[@]}" mkdir -p /opt/gradle
    "${SUDO[@]}" unzip -q -o "$tmp/gradle.zip" -d /opt/gradle
    rm -rf "$tmp"
  fi
  "${SUDO[@]}" ln -sfn "/opt/gradle/gradle-${ver}" /opt/gradle/current
  "${SUDO[@]}" ln -sf /opt/gradle/current/bin/gradle /usr/local/bin/gradle
}

step_java() {
  install_group "14. Java (OpenJDK 25/21 + Temurin 8) & Maven" \
    "$(pick openjdk-25-jdk temurin-25-jdk)" openjdk-21-jdk temurin-8-jdk maven
  install_gradle
}

step_dotnet() {
  # NuGet is built into the SDK: `dotnet nuget ...` / `dotnet add package ...`
  install_group "15. .NET SDK 10 + 8" dotnet-sdk-10.0 dotnet-sdk-8.0
}

step_fonts() {
  install_group "17. Bangla fonts" \
    fonts-noto-core fonts-noto-ui-core fonts-lohit-beng-bengali fontconfig
  fc-cache -f >/dev/null 2>&1 || true
}

# --------------------------- Shell env & helpers -----------------------------
step_shell_env() {
  log "Shell environment (bash/zsh: /etc/profile.d, fish: /etc/fish/conf.d)"
  "${SUDO[@]}" tee /etc/profile.d/devbox.sh >/dev/null <<'EOF'
# Managed by devbox-setup.sh
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_NOLOGO=1
for _d in /opt/mssql-tools18/bin /usr/lib/oracle/*/client64/bin "$HOME/go/bin" "$HOME/.dotnet/tools" "$HOME/.local/bin"; do
  if [ -d "$_d" ]; then
    case ":$PATH:" in *":$_d:"*) ;; *) PATH="$PATH:$_d" ;; esac
  fi
done
unset _d
export PATH
if command -v java >/dev/null 2>&1; then
  JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")"
  export JAVA_HOME="${JAVA_HOME%/jre}"
fi
EOF

  "${SUDO[@]}" mkdir -p /etc/fish/conf.d
  "${SUDO[@]}" tee /etc/fish/conf.d/devbox.fish >/dev/null <<'EOF'
# Managed by devbox-setup.sh
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1
set -gx DOTNET_NOLOGO 1
for d in /opt/mssql-tools18/bin /usr/lib/oracle/*/client64/bin $HOME/go/bin $HOME/.dotnet/tools $HOME/.local/bin
    test -d $d; and fish_add_path -aP $d
end
if type -q java
    set -l jh (path dirname (path dirname (path resolve (command -s java))))
    set -gx JAVA_HOME (string replace -r '/jre$' '' $jh)
end
EOF

  log "Helper: php-use"
  "${SUDO[@]}" tee /usr/local/bin/php-use >/dev/null <<'EOF'
#!/usr/bin/env bash
# php-use <ver>  — switch the version behind `php`, `phpize`, `php-config` (e.g. php-use 7.4, php-use 82)
set -euo pipefail
v="${1:-}"; v="${v//./}"
if [[ -z "$v" ]]; then
  echo "Usage: php-use <ver>   installed:"
  update-alternatives --list php | sed -E 's|.*php|  |'
  exit 1
fi
v="${v:0:1}.${v:1}"
[[ -x "/usr/bin/php$v" ]] || { echo "PHP $v is not installed"; exit 1; }
for t in php phpize php-config; do
  [[ -x "/usr/bin/$t$v" ]] && sudo update-alternatives --set "$t" "/usr/bin/$t$v" >/dev/null
done
php -v | head -n 1
EOF

  log "Helper: jdk-use"
  "${SUDO[@]}" tee /usr/local/bin/jdk-use >/dev/null <<'EOF'
#!/usr/bin/env bash
# jdk-use <8|21|25>  — switch java/javac; open a new shell afterwards to refresh JAVA_HOME
set -euo pipefail
case "${1:-}" in
  8)  pat='temurin-8|java-8-' ;;
  21) pat='temurin-21|java-21-' ;;
  25) pat='temurin-25|java-25-' ;;
  *)  echo "Usage: jdk-use <8|21|25>"; exit 1 ;;
esac
for tool in java javac; do
  p="$(update-alternatives --list "$tool" 2>/dev/null | grep -E "$pat" | head -n 1 || true)"
  if [[ -n "$p" ]]; then sudo update-alternatives --set "$tool" "$p"; else echo "No $tool alternative for JDK $1"; fi
done
java -version 2>&1 | head -n 1
echo "Run 'exec \$SHELL' to refresh JAVA_HOME."
EOF
  "${SUDO[@]}" chmod 0755 /usr/local/bin/php-use /usr/local/bin/jdk-use

  /usr/local/bin/jdk-use "$DEFAULT_JDK" || warn "Could not set default JDK $DEFAULT_JDK"
}

# --------------------------------- Summary -----------------------------------
ver() {  # ver <label> <cmd...>  — ✔ only if the command actually runs successfully
  local label="$1" out rc; shift
  if ! command -v "$1" >/dev/null 2>&1; then
    printf '  \033[31m✘\033[0m %-12s not found\n' "$label"; return 0
  fi
  out="$("$@" 2>&1)" && rc=0 || rc=$?
  out="$(grep -m1 -v '^[[:space:]]*$' <<< "$out" || true)"
  if (( rc == 0 )); then
    printf '  \033[32m✔\033[0m %-12s %s\n' "$label" "$out"
  else
    printf '  \033[31m✘\033[0m %-12s BROKEN (rc=%s): %s\n' "$label" "$rc" "$out"
    echo "$label -> runs but fails: $out" >> "$MISSING_FILE"
  fi
}

# Warn when a tool resolves outside the container's system paths (e.g. nvm/sdkman in the shared $HOME)
shadow_check() {
  local t p
  log "PATH shadowing check"
  for t in php node npm java python3 go ruby dotnet composer; do
    p="$(command -v "$t" 2>/dev/null || true)"
    [[ -z "$p" ]] && continue
    case "$p" in
      /usr/bin/*|/usr/sbin/*|/usr/local/bin/*|/usr/lib*/*|/opt/*) ;;
      *) warn "$t resolves to $p (not the container install) — check PATH / shell rc in \$HOME" ;;
    esac
  done
  if [[ -n "${JAVA_HOME_HOST:-}" && "$JAVA_HOME_HOST" != "$JAVA_HOME" ]]; then
    warn "Inherited JAVA_HOME='$JAVA_HOME_HOST' (from host env) was invalid here; /etc/profile.d overrides it on login"
  fi
}

summary() {
  # distrobox forwards host env vars; a host JAVA_HOME breaks mvn/gradle. Derive it from alternatives.
  JAVA_HOME_HOST="${JAVA_HOME:-}"
  if command -v java >/dev/null 2>&1; then
    JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")"
    export JAVA_HOME="${JAVA_HOME%/jre}"
  fi
  shadow_check
  # From here on, check the container's installs, not tools from the shared $HOME.
  PATH="/usr/local/bin:/usr/bin:/bin:/opt/mssql-tools18/bin:$PATH"

  log "Tool versions"
  ver git git --version;           ver tmux tmux -V;              ver fish fish --version
  ver ripgrep rg --version;        ver bat bat --version;         ver eza bash -c 'set -o pipefail; eza --version | sed -n 2p'
  ver fd fd --version;             ver fzf fzf --version;         ver jq jq --version
  ver httpie http --version;       ver htop htop --version;       ver dig dig -v
  ver cmake cmake --version;       ver gcc gcc --version;         ver make make --version
  ver php php -v;                  ver composer composer --version --no-ansi
  ver phpstan phpstan --version;   ver laravel laravel --version
  ver node node --version;         ver npm npm --version;         ver yarn yarn --version
  ver gulp gulp --version;         ver grunt grunt --version
  ver webpack node -p "'webpack ' + require('/usr/local/lib/node_modules/webpack/package.json').version"
  ver parcel parcel --version;     ver lua lua -v;                ver luarocks luarocks --version
  ver go go version;               ver ruby ruby --version;       ver gem gem --version
  ver swipl swipl --version;       ver python3 python3 --version; ver pip3 pip3 --version
  ver virtualenv virtualenv --version;                            ver uv uv --version
  ver rustc rustc --version;       ver cargo cargo --version
  ver java java -version;          ver mvn mvn -v;                ver gradle bash -c 'set -o pipefail; gradle --version | grep -m1 "^Gradle"'
  ver dotnet bash -c 'set -o pipefail; dotnet --list-sdks | cut -d" " -f1 | paste -sd" "'
  ver mysql mysql --version;       ver psql psql --version;       ver redis-cli redis-cli --version
  ver sqlcmd sqlcmd '-?'
  ver sqlplus bash -c 'ls /usr/lib/oracle/*/client64/bin/sqlplus'

  log "PHP extension matrix"
  local exts=(pdo_mysql mysqli pdo_pgsql pgsql oci8 sqlsrv pdo_sqlsrv redis opcache intl xdebug)
  local v bin mods e w=11
  printf '  %-6s' "PHP"; printf "%-${w}s" "${exts[@]}"; echo
  for v in "${PHP_VERSIONS[@]}"; do
    bin="$(php_bin "$v")"
    printf '  %-6s' "$v"
    if [[ -z "$bin" ]]; then echo "not installed"; continue; fi
    mods="$("$bin" -m 2>/dev/null || true)"
    for e in "${exts[@]}"; do
      # pad manually: multibyte ✔ breaks printf width
      if grep -qiE "^(zend )?${e}\$" <<< "$mods"; then printf '✔%*s' $((w-1)) ''; else printf '·%*s' $((w-1)) ''; fi
    done
    echo
  done

  if [[ -s "$MISSING_FILE" ]]; then
    log "Missing or broken"
    sed 's/^/  - /' "$MISSING_FILE"
  fi
  if [[ -s "$FAILED_FILE" ]]; then
    log "Steps that failed"
    sed 's/^/  - /' "$FAILED_FILE"
  fi
  return 0
}

# ---------------------------------- Main -------------------------------------
main() {
  preflight
  run_step "Base system & repositories" step_base
  run_step "Common tools"               step_common
  run_step "Useful tools"               step_useful
  run_step "Monitoring tools"           step_monitoring
  run_step "Networking tools"           step_network
  run_step "Build tools"                step_build
  run_step "Database clients & drivers" step_db_clients
  run_step "PHP versions & extensions"  step_php
  run_step "Composer, PHPStan, Laravel" step_composer
  run_step "Node.js & bundlers"         step_node
  run_step "Lua"                        step_lua
  run_step "Go"                         step_go
  run_step "Ruby"                       step_ruby
  run_step "Prolog"                     step_prolog
  run_step "Python"                     step_python
  run_step "Rust"                       step_rust
  run_step "Java, Maven, Gradle"        step_java
  run_step ".NET"                       step_dotnet
  run_step "Bangla fonts"               step_fonts
  run_step "Shell env & helpers"        step_shell_env
  summary
  log "Done. Open a new shell (exec \$SHELL) to load PATH/JAVA_HOME. Log: $LOG_FILE"
}

main "$@"
