# Complete Torrent Setup

## rtorrent

Helpful resources

  - [Reddit wiki](https://www.reddit.com/r/seedboxes/wiki/guides/xmlrpc-c_libtorrent_rtorrent/)
  - [Reddit user discusses building and installing xmlrpc-c, libtorrent 
  and rtorrent](https://www.reddit.com/r/seedboxes/comments/e2p4mv).
  - [Auto install script for rtorrent with RuTorrent as 
  GUI](https://github.com/Kerwood/Rtorrent-Auto-Install)

  **Installation PATH and FLAGS**

  - [What is `PKG_CONFIG_PATH` environment variable?](https://askubuntu.com/questions/210210/)
  - [Guide to pkg-config](https://people.freedesktop.org/~dbn/pkg-config-guide.html)

### Installation

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
wget https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.13.8.tar.gz
tar zxf v0.13.8.tar.gz
cd libtorrent-0.13.8/
module load xmlrpc-c/1.59.01-stable openssl/3.1.3
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


### Configuration and running

  - [Archlinux wiki](https://wiki.archlinux.org/title/RTorrent#Configuration)

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
