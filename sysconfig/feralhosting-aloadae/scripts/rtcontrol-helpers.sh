#!/usr/bin/env bash

function rt-unregistered() {
    local mycmd
    mycmd="${@}"
    [[ -z "${mycmd}" ]] && mycmd="-qo'alias,name'"
    rtcontrol 'message=/.*Failure.*Unregistered.*/' $( eval echo ${mycmd} )
}

function rt-orphan() {
    local cwd
    local tgt
    cwd=$( pwd )
    tgt="${1:-$cwd}"
    rtcontrol -qO orphans.txt.default // -Ddir="${tgt}"
}

function _rt_path_selector() {
    local fpath
    local escaped_fpath
    fpath=$( realpath "${1}" )
    escaped_fpath=$( printf '%q' "${fpath}" | sed 's/\\././g;s/+/./g' )
    echo path='/^'"${escaped_fpath}"'.*$/'
}

function _rt_name_selector() {
    local fname
    local escaped_fname
    fname="${1}"
    escaped_fname=$( printf '%q' "${fname}" | sed 's/\\././g;s/+/./g' )
    echo name='/^'"${escaped_fname}"'.*$/'
}


# Recursive search to find if there are any file under this path
# which has completed downloading with 'timelimit' condition.
#       y : year 
#       m : month
#       w : week
#       d : day
#       h : hour
#       i : minute
#       s : second
function rt-completed-inactive() {
    rtcontrol -q -o'path' is_complete=y completed=+60s last_xfer=+6h $( _rt_path_selector "${1}" )
}

function rt-completed() {
    rtcontrol -q -o'path' is_complete=y completed=+60s $( _rt_path_selector "${1}" )
}


function _is_rt_metafile_ok() {
    local metafile
    local mhash
	metafile="${1}"
    if [[ -f "${metafile}" ]]; then
		mhash=$( lstor -qo __hash__ "${metafile}" )
        [[ "${mhash}" =~ [0-9a-fA-F]{40} ]] || return 1
    else
        return 1
    fi  
}

function rt-trackerannounce() {
    rtselect_string="${@}"
    rtselect_string="${rtselect_string:-//}"
    rtcontrol $( eval echo ${rtselect_string} ) -qo'hash' | while read -r -d $'\n' mhash; do rtcontrol hash=$mhash --exec "d.tracker_announce={{item.hash}}" --yes; done
}

function rt-fix-bencoded-error() {
    rt-trackerannounce message=/.*Could.not.parse.bencoded.data.*/
}
