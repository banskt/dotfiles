#!/bin/bash

## alias update-texlive-repository='sudo wget --mirror --no-parent -nH --cut-dirs=5 -o /opt/texlive-repository/update_log.txt -P /opt/texlive-repository/ ftp://ftp.gwdg.de/pub/ctan/systems/texlive/tlnet/'
## alias update-texlive-repository='sudo wget --mirror --no-parent -nH --cut-dirs=4 -o /opt/texlive-repository/update_log.txt -P /opt/texlive-repository/ ftp://mirrors.rit.edu/CTAN/systems/texlive/tlnet/'

update-texlive-repository () {
    if [[ ! -z "${1}" ]] && [[ -d "${1}" ]] && [[ "${1:0-1}" != "/" ]]; then
        sudo wget --mirror --no-parent -nH --cut-dirs=4 -o ${1}/update_log.txt -P ${1}/ ftp://mirrors.rit.edu/CTAN/systems/texlive/tlnet/
    else
        echo "Wrong command."
        echo "Usage:"
        echo "    update-texlive-repository <path/to/repository>."
        echo "    Do not include trailing slash for the directory."
        echo "    For example, update-texlive-repository /opt/texlive  is correct."
        echo "                 update-texlive-repository /opt/texlive/ is wrong."
    fi
}

## TexLive
## Add /opt/texlive/2020/texmf-dist/doc/man to MANPATH.
## Add /opt/texlive/2020/texmf-dist/doc/info to INFOPATH.
## Most importantly, add /opt/texlive/2020/bin/x86_64-linux
## to your PATH for current and future sessions.
## Logfile: /opt/texlive/2020/install-tl.log
##
## The source directory can be specified in .custom/bashrc
[[ -z "${TEXLIVESRC}" ]] && TEXLIVESRC="/opt/texlive/2020"
export INFOPATH="${TEXLIVESRC}/texmf-dist/doc/info:$INFOPATH"
export MANPATH="${TEXLIVESRC}/texmf-dist/doc/man:$MANPATH"
export PATH="${TEXLIVESRC}/bin/x86_64-linux:$PATH"
