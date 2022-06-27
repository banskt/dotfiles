#!/bin/bash

## alias update-texlive-repository='sudo wget --mirror --no-parent -nH --cut-dirs=5 -o /opt/texlive-repository/update_log.txt -P /opt/texlive-repository/ ftp://ftp.gwdg.de/pub/ctan/systems/texlive/tlnet/'
## alias update-texlive-repository='sudo wget --mirror --no-parent -nH --cut-dirs=4 -o /opt/texlive-repository/update_log.txt -P /opt/texlive-repository/ ftp://mirrors.rit.edu/CTAN/systems/texlive/tlnet/'

update-texlive-repository () {
    if [[ -d "${1}" ]]; then
        sudo wget --mirror --no-parent -nH --cut-dirs=4 -o ${1}/update_log.txt -P ${1}/ ftp://mirrors.rit.edu/CTAN/systems/texlive/tlnet/
    else
        echo "Wrong command. Use like: update-texlive-repository <path/to/repository>. Do not include trailing slash."
    fi
}
