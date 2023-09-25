# Complete Torrent Setup

## rtorrent

[rTorrent](https://rakshasa.github.io/rtorrent/) 
is a quick and efficient BitTorrent client that uses, 
and is in development alongside, the 
[libTorrent](https://github.com/rakshasa/libtorrent) protocol.
It is written in C++ and provides a terminal-based user interface 
via the ncurses programming library. 
When combined with a terminal multiplexer (e.g. GNU Screen or Tmux) 
and Secure Shell, it becomes a convenient remote BitTorrent client.

rTorrent has excellent scripting abilities, 
albeit mostly undocumented unless you read the source.


### Installation

I installed `rTorrent` and its dependencies in a non-standard location.
The installation configuration required correct path and library specifications,
for which used the powerful `pkg-config` in Linux.

Here are some resources which were helpful:

  - [Reddit wiki](https://www.reddit.com/r/seedboxes/wiki/guides/xmlrpc-c_libtorrent_rtorrent/)
  - [Reddit user discusses building and installing xmlrpc-c, libtorrent 
  and rtorrent](https://www.reddit.com/r/seedboxes/comments/e2p4mv).
  - [Auto install script for rtorrent with RuTorrent as 
  GUI](https://github.com/Kerwood/Rtorrent-Auto-Install)

**Installation PATH and FLAGS**

  - [What is `PKG_CONFIG_PATH` environment variable?](https://askubuntu.com/questions/210210/)
  - [Guide to pkg-config](https://people.freedesktop.org/~dbn/pkg-config-guide.html)

Installation of rtorrent requires `xmlrpc-c` and `libtorrent`.
Other library prerequisites are installed using `apt`.
```bash
sudo apt install libncurses-dev libtool
```

#### xmlrpc

[XML-RPC](https://xmlrpc-c.sourceforge.io/)
is a quick-and-easy way to make procedure calls over the Internet. 
It converts the procedure call into an XML document, 
sends it to a remote server using HTTP, and gets back the response as XML.

Install `xmlrpc-c` from [source](https://github.com/mirror/xmlrpc-c).
Configuration options can be seen using `./configure --help` and are briefly explained 
[here](https://www.reddit.com/r/seedboxes/wiki/guides/xmlrpc-c_info/).

```bash
git clone git@github.com:mirror/xmlrpc-c.git
cd xmlrpc-c/stable
./configure --prefix=/opt/xmlrpc-c/1.59.01-stable --disable-cplusplus --disable-wininet-client --disable-libwww-client --disable-abyss-server --disable-abyss-threads --disable-abyss-openssl --disable-cgi-server
make -j2
sudo make install
```

I created a modulefile to load xmlrpc-c paths and flags from the non-standard location.
```tcl
#%Module

proc ModulesHelp { } {
    global version

    puts stderr "\tLoads xmlrpc-c $version for common environment variables"
    puts stderr "\tand make it available for pkg-config."
}

module-whatis	"appends xmlrpc-c paths in common environment variables"

# for Tcl script use only
set	version		1.59.01-stable
set	prefix		{/opt/xmlrpc-c/1.59.01-stable}

prepend-path    PATH			$prefix/bin
prepend-path    LD_LIBRARY_PATH 	$prefix/lib
prepend-path    LIBRARY_PATH 		$prefix/lib
prepend-path	CPATH			$prefix/include
prepend-path	PKG_CONFIG_PATH		$prefix/lib/pkgconfig
```

#### libTorrent

[libTorrent](https://github.com/rakshasa/libtorrent) 
is the BitTorrent library used by rtorrent 
and is somehow different from
[libtorrent](https://libtorrent.org/).

```bash
module load xmlrpc-c/1.59.01-stable openssl/3.1.3
wget https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.13.8.tar.gz
tar zxf v0.13.8.tar.gz
cd libtorrent-0.13.8/
./autogen.sh
./configure --prefix=/opt/libtorrent/0.13.8 --disable-debug --with-posix-fallocate
make -j2
sudo make install
```
I do not really understand `--disable-debug` and `--with-posix-fallocate` (test for and enable fallocate)
but [common knowledge](https://www.reddit.com/r/seedboxes/comments/e2p4mv)
is to install with these options.

Edit: The reason is explained in [Archlinux](https://wiki.archlinux.org/title/RTorrent#Pre-allocation).
rTorrent has the ability to pre-allocate space for a torrent. 
The major benefit is that it limits and avoids fragmentation of the filesystem. 
However, this introduces a delay during the pre-allocation 
if the filesystem does not support the fallocate syscall natively.
Therefore the switch `system.file.fallocate=1` in `~/.rtorrent.rc`
is recommended for xfs, ext4, btrfs and ocfs2 filesystems, 
which have native fallocate syscall support. 
They will see no delay during preallocation and no fragmented filesystem. 
Pre-allocation on others filesystems will cause a delay but will not fragment the files.
The flag `--with-posix-fallocate` makes pre-allocation available 
on filesystems other than the above - albeit at a delay.

Post-installation note:
```default
Libraries have been installed in:
   /opt/libtorrent/0.13.8/lib

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the '-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the 'LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the 'LD_RUN_PATH' environment variable
     during linking
   - use the '-Wl,-rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to '/etc/ld.so.conf'

See any operating system documentation about shared libraries for
more information, such as the ld(1) and ld.so(8) manual pages.
```

I created a modulefile to load libtorrent paths and flags from the non-standard location
```tcl
#%Module

proc ModulesHelp { } {
    global version

    puts stderr "\tLoads libtorrent $version for common environment variables"
    puts stderr "\tand make it available for pkg-config."
}

module-whatis	"appends libtorrent paths in common environment variables"

# requires
prereq		openssl
prereq		xmlrpc-c

# for Tcl script use only
set	version		0.13.8
set	prefix		{/opt/libtorrent/0.13.8}

prepend-path    LD_LIBRARY_PATH 	$prefix/lib
prepend-path    LD_RUN_PATH	 	$prefix/lib
prepend-path    LIBRARY_PATH 		$prefix/lib
prepend-path	CPATH			$prefix/include
prepend-path	PKG_CONFIG_PATH		$prefix/lib/pkgconfig
```

#### rtorrent

```
module load libtorrent/0.13.8
wget https://github.com/rakshasa/rtorrent-archive/raw/master/rtorrent-0.9.8.tar.gz --no-check-certificate
tar zxf rtorrent-0.9.8.tar.gz
cd rtorrent-0.9.8/
./autogen.sh
./configure --prefix=/opt/rtorrent/0.9.8 --disable-debug --with-xmlrpc-c
make -j2
sudo make install
```

I created a modulefile for loading rtorrent with the prerequisites
```tcl
#%Module

proc ModulesHelp { } {
    global version

    puts stderr "\tLoads rtorrent $version with proper environment prerequisites."
}

module-whatis	"loads rtorrent with proper environmnet prerequisites."

# requires
prereq		xmlrpc-c

# for Tcl script use only
set	version		0.9.8
set	prefix		{/opt/rtorrent/0.9.8}

prepend-path    PATH			$prefix/bin
```

How to load rtorrent for non-interactive shells?

#### ruTorrent

  - [Github repository](https://github.com/Novik/ruTorrent)
  - [Github wiki](https://github.com/Novik/ruTorrent/wiki)

ruTorrent is a web frontend for rtorrent. 
It is a PHP project and does not require a running daemon.
The idea is to keep the PHP project in the document root of a web server
with XMLRPC calls to the running rtorrent daemon.

In my setup, the web server is run by user `minion`
and the rtorrent service is run by the default user, say `user1`.
The user `minion` does not have root privileges.
`minion` and `user1` are members of a common group called `minion`.

```bash
module load rtorrent/0.9.8
cd /path/to/web/document/root
git clone git@github.com:Novik/ruTorrent.git rutorrent
sudo chgrp -R minion rutorrent
```

However running the frontend requires proper configuration and settings,
as well as connection to the rtorrent scgi socket.


### Configuration and running

  - [Archlinux wiki](https://wiki.archlinux.org/title/RTorrent#Configuration)
  - [List of all commands](https://rtorrent-docs.readthedocs.io/en/latest/genindex.html)
  - [Autostarting rtorrent at boot time](https://rtorrent-docs.readthedocs.io/en/latest/cookbook.html#the-rtorrent-command-line)

Here is a quick list of files which had to be configured:

  - `nginx.conf` and the files included therein for my particular setup.
  - `rutorrent/conf/config.php`
  - `rutorrent/conf/plugins.ini`
  - `rutorrent/php/settings.php` - Bug fix for PHP 8.2
  - `rutorrent/plugins/cpuload/cpu.php` - Bug fix for PHP 8.2
  - `~/.rtorrent.rc`

#### XMLRPC Setup

Configure rTorrent to expose the endpoint to a local unix domain socket
instead of address + port because
[the later is less secure](https://github.com/rakshasa/rtorrent/wiki/RPC-Setup-XMLRPC).

In the `nginx.conf`, include the `scgi` config:
```nginx
location /canbeanything {
    include         /opt/nginx/conf/scgi_params;
    scgi_pass       unix:/home/banskt/local/etc/rtorrent/session/rpc.socket;
}
```
and in `rutorrent/conf/config.php` include:
```php
    $scgi_port = 0;
    $scgi_host = "unix:///home/banskt/local/etc/rtorrent/session/rpc.socket";

    // $XMLRPCMountPoint = "/RPC2";     // DO NOT DELETE THIS LINE!!! DO NOT COMMENT THIS LINE!!!
    $XMLRPCMountPoint = "/canbeanything";
```
However, the `$XMLRPCMountPoint` had no effect.
This was probably because rutorrent is using "rpc" and/or "httprpc" plugin
[GitHub Issue](https://github.com/Novik/ruTorrent/issues/1895).
Also [RPC Plugin is not recommended](https://github.com/Novik/ruTorrent/wiki/PluginRPC).
Therefore, I disabled the RPC and HTTPRPC plugins in `conf/plugins.ini`.
```ini
[rpc]
enabled = no

[httprpc]
enabled = no
```
After disabling RPC and HTTPRPC, the `$XMLRPCMountPoint` had the intended effect.


> FeralHosting uses a strang mount point.
> `$XMLRPCMountPoint = '//rutorrent:@'.gethostname().'/'.$_pw['name'].'/RPC';`
> => `//rutorrent:@aloadae/banskt/RPC`.
> What is happening there?

#### rutorrent plugins

I disabled some other plugins for rutorrent.

```ini
[_cloudflare]
enabled = no
```
The `_cloudflare` plugin allows to scrape the DDOS protection from Cloudflare.
It requires Python and `cloudscraper` module. 
I do not have Python installed yet.

```ini
[spectrogram]
enabled = no
```
Requires installing sox.

```ini
[screenshots]
enabled = no
```
Requires installing ffmpeg. This is a cool feature and I will enable it if I install ffmpeg.

Read more about plugins:

  - [rutorrent plugins wiki](https://github.com/Novik/ruTorrent/wiki/Plugins).


#### Open Port

  - Specify a port in `~/.rtorrent.rc`. 
  - Create `/etc/ufw/applications.d/rtorrent`.
```ini
[rTorrent]
title=BitTorrent client
description=rTorrent is a quick and efficient BitTorrent client written in C++.
ports=xxx/tcp
```
  - Open the port
```bash
sudo ufw allow rTorrent
sudo ufw status verbose
```

#### Authentication
Configure access of the website using nginx 
[Basic Authentication](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/).
This is not secure and should not be used in production environmnets.
```bash
sudo apt install apache2-utils
sudo htpasswd -c /path/to/.htpasswd user1
sudo apt purge apache2-utils
```
I don't apache2-utils going forward.

Alternatively, encrypted password can also be generated using
```bash
openssl passwd -apr1 <password_string>
```
The generated \<encrypted\_password\_string\> can be stored in `.htpasswd`:
```default
user1:<encrypted_password_string>
```

Include the password in `nginx.conf`:
```nginx
location /rutorrent {
    auth_basic user1;
    auth_basic_user_file /path/to/.htpasswd;
}
```

#### rutorrent bug fix for PHP8.2

I modified `rutorrent/php/settings.php` because 
`rTorrentSettings::$modified` was not defined and was being
created dynamically.
[Dynamic properties are deprecated in
PHP 8.2](https://wiki.php.net/rfc/deprecate_dynamic_properties).

```bash
$ git diff php/settings.php
diff --git a/php/settings.php b/php/settings.php
index ee3d6138..5d2f4a02 100644
--- a/php/settings.php
+++ b/php/settings.php
@@ -28,6 +28,7 @@ class rTorrentSettings
        public $home = '';
        public $tz = null;
        public $ip = '0.0.0.0';
+    public $modified;

        static private $theSettings = null;
```

And, here is the same modification for `plugins/cpuload/cpu.php`

```bash
$ git diff plugins/cpuload/cpu.php
diff --git a/plugins/cpuload/cpu.php b/plugins/cpuload/cpu.php
index 7aa4ff07..0a974cd4 100644
--- a/plugins/cpuload/cpu.php
+++ b/plugins/cpuload/cpu.php
@@ -7,6 +7,7 @@ class rCPU
 {
        public $hash = "cpu.dat";
        public $count = 1;
+    public $modified;

        static public function load()
        {
```



#### Supporting libraries

  - mktorrent 
  - ffmpeg

#### systemd control

  - Create a launcher script for starting rtorrent,
  see `~/.dotfiles/bin/rtorrent-launcher`

  - Create a systemd file in `/lib/systemd/system/rtorrent@.service`
  and enable the service.
```bash
sudo systemctl enable rtorrent@banskt
```
The start/stop/restart can be controlled by `systemctl`.
```bash
sudo systemctl <start/stop/reload> rtorrent@banskt
```
There are several things to note here,
in particular `Type=` (see
[documentation](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
or in simple words, [this StackOverflow answer](https://superuser.com/a/1274913).
Another important thing to consider is which kill signal is sent.
SIGKILL is never safe.

  - Check: If you kill the process using `rtorrent-launcher stop`,
  is it recognized by `systemd`? Yes.


**To-Do:** 

  - [ ] Use OpenID Connect / OAuth2
  - [ ] Enable cloudflare plugin after installing Python
  - [ ] Use mktor from pyrocore instead of mktorrent
  - [ ] Configure rutorrent `Create` plugin with mktorrent.
  - [ ] Disable rutorrent `Get` plugin because webserver user do not have access of media library. 



## Mediainfo

Download latest files from [MediaArea](https://mediaarea.net/en/MediaInfo/Download/Ubuntu).

```bash
wget https://mediaarea.net/download/binary/mediainfo/23.09/mediainfo_23.09-1_amd64.xUbuntu_22.04.deb
wget https://mediaarea.net/download/binary/libmediainfo0/23.09/libmediainfo0v5_23.09-1_amd64.xUbuntu_22.04.deb
wget https://mediaarea.net/download/binary/libzen0/0.4.41/libzen0v5_0.4.41-1_amd64.Ubuntu_22.10.deb
sudo dpkg -i libzen0v5_0.4.41-1_amd64.Ubuntu_22.10.deb
sudo apt install libmms0
sudo dpkg -i libmediainfo0v5_23.09-1_amd64.xUbuntu_22.04.deb
sudo dpkg -i mediainfo_23.09-1_amd64.xUbuntu_22.04.deb
```

## Pyrocore

## Test internet speed

There are a few options to check the 
[bandwidth speed from command line](https://superuser.com/q/70399)

### iperf

iperf is simple and easy to use.
```bash
sudo apt install iperf3
```

It requires a client and server.

```default
(on the server)

 user@server$ sudo ufw allow <port>/tcp
 user@server$ iperf3 -s -p <port>

(on the client)

 user@client$ iperf3 -c <server.domain> -p <port> -t 60

Connecting to host <server.domain>, port <port>
[  4] local 185.21.217.17 port 55648 connected to <server.domain> port <port>
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec  79.9 MBytes   670 Mbits/sec    1   2.99 MBytes       
[  4]   1.00-2.00   sec  43.8 MBytes   367 Mbits/sec    0   4.33 MBytes       
[  4]   2.00-3.00   sec  35.0 MBytes   294 Mbits/sec    0   3.70 MBytes       
[  4]   3.00-4.00   sec  43.8 MBytes   367 Mbits/sec    0   5.38 MBytes       
[  4]   4.00-5.00   sec  48.8 MBytes   409 Mbits/sec    5   4.96 MBytes      
   .
   .
   .
   .
   .
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-60.00  sec  2.63 GBytes   377 Mbits/sec    4             sender
[  4]   0.00-60.00  sec  2.59 GBytes   371 Mbits/sec                  receiver
```

### Remove startup scripts

```bash
systemctl disable --now apt-daily{,-upgrade}.{timer,service}
dpkg-reconfigure unattended-upgrades
```
