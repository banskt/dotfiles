#!/bin/bash

# load common plugins
dotsrc ${DOTFILES}/bash/common

# link to local bin
export PATH="${PATH}:${DOTFILES}/bin"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# tunnel to vultr port 80 (to access local website for dev)
alias vultr-80-open='ssh-localportfwd open vultr 80 8085'
alias vultr-80-close='ssh-localportfwd close vultr 80 8085'
