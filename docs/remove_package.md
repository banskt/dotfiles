# Usefule commands for package management

I commonly use `apt install <package>`, `apt-cache search "partial-package-name"` and `apt-cache show <package>`.
Here is a cheatsheet for some other commands, which are useful but I always had to Google
before listing them here.

  - Remove package only, configuration (/etc) and personal data (/home) are not removed.
```bash```
apt remove <package>
```

  - Remove package and configuration, personal data is not removed
```bash
apt purge <package>
```

  - No apt command removes personal data in `/home`. You must delete that yourself.

  - Find if a package is installed
```bash
apt list <package> # can also use wildcard
```
Example:
```
### $ apt list apache2*
### apache2-bin/jammy-updates 2.4.52-1ubuntu4.6 amd64
### apache2-data/jammy-updates 2.4.52-1ubuntu4.6 all
### apache2-doc/jammy-updates 2.4.52-1ubuntu4.6 all
### apache2-ssl-dev/jammy-updates 2.4.52-1ubuntu4.6 amd64
### apache2-suexec-custom/jammy-updates 2.4.52-1ubuntu4.6 amd64
### apache2-suexec-pristine/jammy-updates 2.4.52-1ubuntu4.6 amd64
### apache2-utils/jammy-updates,now 2.4.52-1ubuntu4.6 amd64 [installed]
### apache2/jammy-updates 2.4.52-1ubuntu4.6 amd64
```

  - List files installed by a package
```bash
dpkg -L <package>
```

  - List files which will be installed by a file before installing.
```bash
apt-file <package>
dpkg --contents <package>
```

  - Find which package provides a file that is already on your system
```bash
dpkg -S /path/to/installed/file
```

  - Find which package will provide a file that is not currently on your system
```bash
apt-file search /path/to/file
```
