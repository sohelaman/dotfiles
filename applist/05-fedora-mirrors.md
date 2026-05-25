# Fedora 44

## Edit DNF Config /etc/dnf/dnf.conf
```toml
[main]
fastestmirror=True
max_parallel_downloads=10
minrate=1k
timeout=15
```

## RPM Fusion & Remi
```bash
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf install https://rpms.remirepo.net/fedora/remi-release-$(rpm -E %fedora).rpm
```

## Sublime Text
```bash
rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
dnf config-manager addrepo --from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
```

## VSCode
```bash
rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo > /dev/null
```

## Docker
```bash
dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
```

## NVIDIA Container Toolkit
```bash
dnf config-manager addrepo --from-repofile=https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo
sed -i '/^sslcacert=/d' /etc/yum.repos.d/nvidia-container-toolkit.repo
```

## Create File /etc/yum.repos.d/xeonbd-fedora.repo
```toml
[xeonbd-fedora]
name=Fedora $releasever - $basearch - XeonBD Local Mirror
baseurl=https://mirror.xeonbd.com/fedora/linux/releases/$releasever/Everything/$basearch/os/
enabled=1
repo_gpgcheck=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch

[xeonbd-fedora-updates]
name=Fedora $releasever - $basearch - Updates - XeonBD Local Mirror
baseurl=https://mirror.xeonbd.com/fedora/linux/updates/$releasever/Everything/$basearch/
enabled=1
repo_gpgcheck=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
```

## Flathub
```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

## Temurin Java
```bash
dnf install adoptium-temurin-java-repository
fedora-third-party enable

```

## Cache
```bash
dnf clean all
dnf check-update
dnf makecache
```
