#!/usr/bin/env bash

# Per-user tmp directory
# This will set $TMPDIR and create ~/.tmp for temporary files
. /etc/profile.d/01tmpdir.sh

# Put your fun stuff here.
# Enables ^s and ^q in rTorrent, when running in screen
stty -ixon -ixoff
