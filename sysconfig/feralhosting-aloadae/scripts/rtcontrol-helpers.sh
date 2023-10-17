#!/usr/bin/env bash

function rt-error() {
    mycmd="${@}"
    rtcontrol -qo 'tracker,name' 'message=/.*Failure.*Unregistered.*/' ${mycmd}
}

function rt-orphan() {
    cwd=$( pwd )
    tgt="${1:-$cwd}"
    rtcontrol -qO orphans.txt.default // -Ddir="${tgt}"
}

function rt-loaded() {
    cwd=$( pwd )
    tgt="${1:-$cwd}"
    find "${tgt}"/ -mindepth 1 -maxdepth 1 -print0 | while read -r -d $'\0' mdir; 
    do 
        name=$( basename "$mdir" )
        mhash=$( rtcontrol -qo hash name="$name" )
        [[ ! -z "${mhash}" ]] && [[ "${mhash}" =~ [0-9a-fA-F]{40} ]] && echo "${name}"
    done
}
