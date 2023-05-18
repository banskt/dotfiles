#!/usr/bin/env bash

## History Control
## Adapted from 
##     - https://unix.stackexchange.com/questions/18212
##     - https://github.com/Bash-it/bash-it/blob/master/plugins/available/history-eternal.plugin.bash
## Store history in a separate directory ~/.bash_history
## with history of each month in separate files.

export HISTDIR=~/.bash_history
export HISTFILE=~/.bash_history/$(date +%Y-%m)

[[ -d ${HISTDIR?} ]] || mkdir -p "${HISTDIR?}"

test -d ~/.bash_history/ || mkdir ~/.bash_history/

if [[ ${BASH_VERSINFO[0]} -lt 4 ]] || [[ ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -lt 3 ]]; then
	#_log_warning "Bash version 4.3 introduced the 'unlimited' history size capability."
    export HISTSIZE=
    export HISTFILESIZE=
else
    ## unlimited history and unlimited historyfilesize
    export HISTSIZE=-1
    export HISTFILESIZE='unlimited'
fi
## don't put duplicate lines
HISTCONTROL=ignoredups
## append to the history file, don't overwrite it
shopt -s histappend
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

## search for a command using
##    $ myhist whatever-command-you-are-searching
myhist() {
    grep -a $@ ~/.bash_history/*
}
