#!/bin/bash

FILES=(.bashrc)
DOTFILES=~/.dotfiles

# remember current location
CWD=$( pwd )

# provide path with respect to home
cd ${HOME}

for __file in ${FILES[@]}; do
    if [[ -f ${__file} ]]; then
        __linktgt=${DOTFILES}/bash/bashrc
        # backup if this is not a link
        if [[ ! -L ${__file} ]]; then 
            __bakfile=${__file}_$( date +%Y-%m-%d )
            cp ${__file} ${__bakfile}
        fi
        ln -s --force ${__linktgt} ${__file}
        #echo ${__file} ${__bakfile} ${__linktgt}
    fi
done

# go back to initial location
cd ${CWD}
