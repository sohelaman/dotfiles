
# FISH SHELL SCRIPT


## Environment specific paths
if test $OS_ENV = 'arch'
	set www_dir '/srv/http/'
	set access_log_file '/var/log/httpd/access_log'
	set error_log_file '/var/log/httpd/error_log'
	set php_ini_file '/etc/php/php.ini'
	set my_cnf_file '/etc/mysql/my.cnf'
	set vhosts_file '/etc/httpd/conf/extra/httpd-vhosts.conf'
else if test $OS_ENV = 'debian'; or test $OS_ENV = 'ubuntu'
	set www_dir '/var/www'
	set access_log_file '/var/log/apache2/access.log'
	set error_log_file '/var/log/apache2/error.log'
	set php_ini_file '/etc/php5/apache2/php.ini'
	set my_cnf_file '/etc/mysql/my.cnf'
else
	set_color red
	echo "This OS is not supported. Some scripts and commands won't work."
	set_color normal
end


## Add composer binaries to path
if type -q composer
	set -gx PATH $PATH ~/.config/composer/vendor/bin
end

if type -q java
	set -Ux JAVA_HOME '/usr/lib/jvm/java-8-openjdk'
end
