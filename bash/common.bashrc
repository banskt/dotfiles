#!/bin/bash

# load common plugins
dotsrc ${DOTFILES}/bash/common

# link to local bin
export PATH="${PATH}:${DOTFILES}/bin"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
