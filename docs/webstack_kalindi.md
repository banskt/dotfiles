# Webstack in Kalindi

Create a group for web development. Also create a separate user for the installation with home directory (`-m`) and bash shell (`-s /bin/bash`). Add the new user to the sudoers list and create the `/opt/webstack` directory for installation.

```
sudo groupadd webdev
sudo usermod -a -G webdev saikat
sudo useradd -g webdev -m -c "User account for webstack" -s /bin/bash webdev
sudo usermod -a -G sudo webdev
sudo passwd webdev
su -l webdev
sudo mkdir /opt/webstack
sudo chown -R webdev:webdev /opt/webstack
```

### Nginx

Download the source files from [nginx.org](https://www.nginx.org/en/download.html). Detailed instructions for [configuration](https://nginx.org/en/docs/configure.html) and [installation](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#sources). I used the latest stable release.

```
# Install PCRE, zlib and OpenSSL
sudo apt install libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev

# Configure and build nginx
mkdir -p apps/nginx
cd app/nginx
wget https://nginx.org/download/nginx-1.18.0.tar.gz
tar -zxf nginx-1.18.0.tar.gz
cd nginx-1.18.0/
./configure --prefix=/opt/webstack/nginx/1.18.0 --builddir=../nginx-1.18.0-build --with-http_ssl_module
make -f ../nginx-1.18.0-build/Makefile -j 8
sudo make -f ../nginx-1.18.0-build/Makefile install
```

Finally make sure that log files will be accessible by the user (group permission should be `775` for `/opt/webstack/nginx/1.18.0/logs`)

**How to start and stop**

Since we are not running nginx as root, we have to change the accessible port because the default port 80 is not available to non-root users. Therefore, it's necessary to use a port > 1000. Edit the `/opt/webstack/nginx/1.18.0/nginx.conf` file to use port `8080`.

```bash
/opt/webstack/nginx/1.18.0/sbin/nginx -t # check configuration
/opt/webstack/nginx/1.18.0/sbin/nginx # start nginx
/opt/webstack/nginx/1.18.0/sbin/nginx -s stop # stop nginx
/opt/webstack/nginx/1.18.0/sbin/nginx -s quit # force quit
```

Now,  open the browser at `127.0.0.1:8080` and you will be able to see the welcome message. The SSL connection (`https://127.0.0.1:8080`) will still not work. Do not worry yet.

I created a `systemd` file `/lib/systemd/system/nginx.service` for controlling the `nginx` start / stop

```
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/opt/webstack/nginx/1.18.0/logs/nginx.pid
ExecStartPre=/opt/webstack/nginx/1.18.0/sbin/nginx -t
ExecStart=/opt/webstack/nginx/1.18.0/sbin/nginx
ExecReload=/opt/webstack/nginx/1.18.0/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

**Configuration**

Edit `/opt/webstack/nginx/1.18.0/conf/nginx.conf` . Move the default server to a separate location in `/opt/webstack/nginx/sites-enabled/` so that it can be used by any version of `nginx`. Also, edit the user:

```nginx
user  webdev;
worker_processes auto;

http {
    ...
    ...
     
    include /opt/webstack/nginx/sites-enabled/*;
}
```

Now, new configuration files are created in `/opt/webstack/nginx/sites-enabled/`.

### MySQL

Installing MySQL from source is mildly convoluted and risk non-optimal settings leading to reduced  functionality, performance, or security (see [here](https://dev.mysql.com/doc/refman/8.0/en/source-installation.html)). So, I installed a generic binary as explained [here](https://dev.mysql.com/doc/refman/8.0/en/binary-installation.html).

```bash
sudo apt install libaio1 libtinfo5 # dependency
mkdir mysql && cd mysql
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.22-linux-glibc2.12-x86_64.tar.xz
mkdir -p /opt/webstack/mysql/8.0.22
tar xf mysql-8.0.22-linux-glibc2.12-x86_64.tar.xz -C /opt/webstack/mysql/
```

The postinstallation steps are explained [here](https://dev.mysql.com/doc/refman/8.0/en/postinstallation.html). For the configuration, create a `my.cnf` file with the following content. Log file flags explained in [Stackoverflow](https://stackoverflow.com/questions/5441972/how-to-see-log-files-in-mysql).

```
[mysqld]
basedir=/opt/webstack/mysql/mysql-8.0.22-linux-glibc2.12-x86_64
datadir=/opt/webstack/mysql/mysql-8.0.22-linux-glibc2.12-x86_64/mysql-data

# Enable error log
[mysqld_safe]
log_error=/opt/webstack/mysql/mysql-8.0.22-linux-glibc2.12-x86_64/mysql-logs/mysql_error.log

[mysqld]
log_error=/opt/webstack/mysql/mysql-8.0.22-linux-glibc2.12-x86_64/mysql-logs/mysql_error.log

# General query log
general_log_file = /opt/webstack/mysql/mysql-8.0.22-linux-glibc2.12-x86_64/mysql-logs/mysql.log
general_log      = 1

# Slow Query Log
#log_slow_queries = /opt/webstack/mysql/mysql-8.0.22-linux-glibc2.12-x86_64/mysql-logs/mysql-slow.log
#long_query_time  = 2
#log-queries-not-using-indexes
```

and then run the configuration from within the `/opt/webstack/mysql/mysql-8.0.22-linux-glibc2.12-x86_64` directory:

```bash
mkdir mysql-data mysql-keyfiles mysql-logs
chmod 770 mysql-data mysql-keyfiles mysql-logs
bin/mysqld --defaults-file=./my.cnf --initialize --user=webdev
bin/mysql_ssl_rsa_setup --datadir=./mysql-keyfiles
```

For starting / stopping the MySQL server, we need the `support-files/mysql.server` , where we edit the `basedir` and `datadir`:

```
basedir=/opt/webstack/mysql/mysql-8.0.22-linux-glibc2.12-x86_64
datadir=/opt/webstack/mysql/mysql-8.0.22-linux-glibc2.12-x86_64/mysql-data
```

And link this file to `/etc/init.d`.  Then, we can monitor the service or stop the service.

```bash
chmod 755 support-files
ln -s /opt/webstack/mysql/mysql-8.0.22-linux-glibc2.12-x86_64/support-files/mysql.server /etc/init.d/mysql.server
/etc/init.d/mysql.server status
/etc/init.d/mysql.server stop
/etc/init.d/mysql.server start
```

Alternatively we can start the service directly using `mysqld_safe`:

```
bin/mysqld_safe --user=webdev --defaults-file=./my.cnf
```

I also created a systemd file `/lib/systemd/system/mysql.service` for controlling `MySQL` via `systemctl` ([documentation](https://dev.mysql.com/doc/refman/8.0/en/using-systemd.html))

```
# MySQL systemd service file
  
[Unit]
Description=MySQL Community Server
Documentation=man:mysqld(8)
Documentation=http://dev.mysql.com/doc/refman/en/using-systemd.html
After=network.target
After=syslog.target

[Install]
WantedBy=multi-user.target

[Service]
User=webdev
Group=webdev

# Have mysqld write its state to the systemd notify socket
Type=notify
# PermissionsStartOnly=true
# ExecStartPre=/mysql-systemd-start pre

# Start main service
ExecStart=/opt/webstack/mysql/mysql-8.0.22-linux-glibc2.12-x86_64/bin/mysqld --defaults-file=/opt/webstack/mysql/mysql-8.0.22-linux-glibc2.12-x86_64/my.cnf $MYSQLD_OPTS

# Disable service start and stop timeout logic of systemd for mysqld service.
TimeoutSec=0

# Sets open_files_limit
LimitNOFILE = 10000
Restart=on-failure
RestartPreventExitStatus=1

# Always restart when mysqld exits with exit code of 16. This special exit code
# is used by mysqld for RESTART SQL.
RestartForceExitStatus=16

# Set enviroment variable MYSQLD_PARENT_PID. This is required for restart.
Environment=MYSQLD_PARENT_PID=1
```

Now, we can control MySQL using `systemctl`:

```bash
sudo systemctl status mysql
sudo systemctl start mysql
sudo systemctl status mysql
```

Once we start the server, we can now login and secure the MySQL installation by updating the root password. The temporary root password created by `--initialize` can be obtained from the `mysql_error.log` file.

```bash
bin/mysql -u root -p
```

After connecting, assign a new root password:

```mysql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root-password';
```

Finally, manage permissions for accessing the `bin` by other users.

```
chmod 750 bin
```



### PHP

https://docs.moodle.org/310/en/Compiling_PHP_from_source

```
sudo apt install libxml2-dev libsqlite3-dev libcurl4-openssl-dev libldap2-dev libonig-dev libxslt-dev libjpeg-dev libzip-dev
wget https://www.php.net/distributions/php-8.0.0.tar.gz
tar xvf php-8.0.0.tar.gz
cd php-8.0.0
```

Create the configure file

```bash
./configure \
  --prefix=/opt/webstack/php/8.0.0 \
  --enable-mbstring \
  --with-curl \
  --with-openssl \
  --enable-soap \
  --with-zip \
  --enable-gd \
  --with-jpeg \
  --with-freetype \
  --with-ldap \
  --enable-intl \
  --with-xsl \
  --with-zlib \
  --enable-fpm --with-mysqli
```

Install:

```
./myconfig.sh
make -j 8
make install
```

Configure.

```bash
mkdir -p /opt/webstack/php/8.0.0/etc/conf.d # the modules.ini will be created here
mkdir -p /opt/webstack/php/8.0.0/var/run/php-fpm # the sock file will be created here
cp php.ini-development /opt/webstack/php/8.0.0/lib/php.ini # this is our ini file
cp sapi/fpm/www.conf /opt/webstack/php/8.0.0/etc/php-fpm.d/www.conf # the php-fpm configuration file
cp sapi/fpm/php-fpm.conf /opt/webstack/php/8.0.0/etc/php-fpm.conf
vim /opt/webstack/php/8.0.0/etc/php-fpm.d/www.conf
# edit user=webdev, group=webdev, listen.owner=webdev, listen.group=webdev
# edit listen = '/opt/webstack/php/8.0.0/var/run/php-fpm/php-fpm.sock'
vim /opt/webstack/php/8.0.0/etc/conf.d/modules.ini
# add zend_extension=opcache.so
ln -s /opt/webstack/php/8.0.0/sbin/php-fpm /opt/webstack/php/8.0.0/bin/php-fpm
```

Create systemd file (`/lib/systemd/system/php-fpm.service`):

```
[Unit]
Description=The PHP FastCGI Process Manager
After=syslog.target network.target
 
[Service]
Type=simple
PIDFile=/opt/webstack/php/8.0.0/var/run/php-fpm/php-fpm.pid
ExecStart=/opt/webstack/php/8.0.0/bin/php-fpm --nodaemonize --fpm-config /opt/webstack/php/8.0.0/etc/php-fpm.conf
ExecReload=/bin/kill -USR2 $MAINPID
 
[Install]
WantedBy=multi-user.target
```

Now, we can start, stop, restart or check status of PHP using this service file.

### Put everything together

The goal is to create a start/stop file for starting and stopping our LEMP stack. I created `systemctl` files for `nginx` and `mysql`.  I have already created service files at `/lib/systemd/system` for both `nginx` and `mysql` (see above).

```bash
function lemp() {
    __command=${1}
    if [ "${__command}" == "start" ]; then
        echo "Starting NGINX and MySQL."
        sudo systemctl start php-fpm
        sudo systemctl start nginx
        sudo systemctl start mysql
    elif [ "${__command}" == "stop" ]; then
        echo "Stopping NGINX and MySQL."
        sudo systemctl stop php-fpm
        sudo systemctl stop nginx
        sudo systemctl stop mysql
    fi
    sudo systemctl status php-fpm
    sudo systemctl status nginx
    sudo systemctl status mysql
}
```

Now, I can start / stop the webstack using simple commands:

```bash
lemp # check status of webstack
lemp start # start the service
lemp stop # stop the service
```

### Composer

Composer is a tool for dependency management in PHP. Installation instructions for composer is available [here](https://getcomposer.org/download/).

```bash
su -l webdev
mkdir composer
cd composer
module load php/8.0.0
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/opt/webstack/php/8.0.0/bin --filename=composer
exit
```

### How to install php modules?

Nice instructions [here](https://ma.ttias.be/how-to-compile-and-install-php-extensions-from-source/).

```
su -l webdev
cd apps/php/php-8.0.0/ext/pdo_mysql/modules
cd pdo_mysql
phpize
./configure
make
```

Move the extension to the PHP extension directory

```bash
$ php -i | grep extension_dir
extension_dir => /opt/webstack/php/8.0.0/lib/php/extensions/no-debug-non-zts-20200930 => /opt/webstack/php/8.0.0/lib/php/extensions/no-debug-non-zts-20200930
$ cp modules/pdo_mysql.so /opt/webstack/php/8.0.0/lib/php/extensions/no-debug-non-zts-20200930/
```

Finally edit the `php.ini` file.

```
extension=pdo_mysql
```

