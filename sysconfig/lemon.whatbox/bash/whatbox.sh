#!/usr/bin/env bash

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
# if [[ $- != *i* ]] ; then
#    # Shell is non-interactive.  Be done now!
#    return
# fi

# Per-user tmp directory
# This will set $TMPDIR and create ~/.tmp for temporary files
. /etc/profile.d/01tmpdir.sh

# Put your fun stuff here.
# Enables ^s and ^q in rTorrent, when running in screen
# But test for an interactive screen
[[ $- == *i* ]] && stty -ixon -ixoff

export PATH="${HOME}/usr/scripts:${HOME}/usr/bin:${PATH}"
export EDITOR="/usr/bin/vim"

#function realpath() {
#    realpath $@
#    #realpath "${@}" | sed 's/\/mnt\/mpath.\/banskt/\/home\/banskt/g'
#}
function realpath() {
    /usr/bin/realpath "${@}" | sed 's/\/mnt\/mpath.\/banskt/\/home\/banskt/g'
}
