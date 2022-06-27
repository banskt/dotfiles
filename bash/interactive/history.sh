#!/bin/bash

## History Control
## Adapeted from https://unix.stackexchange.com/questions/18212
## Store history in a separate directory ~/.bash_history
## with history of each month in separate files.
test -d ~/.bash_history/ || mkdir ~/.bash_history/
HISTFILE=~/.bash_history/$(date +%Y-%m)
## unlimited history and unlimited historyfilesize
HISTSIZE=-1
HISTFILESIZE=-1
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
