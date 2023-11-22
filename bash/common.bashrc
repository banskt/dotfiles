#!/usr/bin/env bash

# load common plugins
dotsrc ${DOTFILES}/bash/common

# link to local bin
export PATH="${PATH}:${DOTFILES}/bin"

# make less more friendly for non-text input files, see lesspipe(1)
if [[ -x /usr/bin/lesspipe ]]; then
    is_ubuntu && eval "$(SHELL=/bin/sh lesspipe)" || \
        { export LESSOPEN="| /usr/bin/lesspipe %s";
          export LESSCLOSE="/usr/bin/lesspipe %s %s"; }
fi

# tunnel to vultr port 80 (to access local website for dev)
alias vultr-80-open='ssh-localportfwd open vultr 80 8085'
alias vultr-80-close='ssh-localportfwd close vultr 80 8085'
