#!/usr/bin/env bash
#
#
################################################################################
#                                                                              #
# Scripting Functions                                                          #
#                                                                              #
# These are generally not called from commandline                              # 
# but can be called if required.                                               #
#                                                                              #
################################################################################
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

function _rt_is_metafile() {
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

################################################################################
#                                                                              #
# Alias Functions                                                              #
#                                                                              #
# These are generally used from commandline for daily tasks                    # 
# but can also be used in scripts if required.                                 #
#                                                                              #
################################################################################
function rt-unregistered() {
    local outflag
    outflag="${@}"
    if [[ -z "${outflag}" ]]; then
        rtcontrol 'message=/.*Failure.*Unregistered.*/' -qo'alias,name'
    else
        rtcontrol 'message=/.*Failure.*Unregistered.*/' $outflag
    fi
}


function rt-orphan() {
    local tgt
    tgt="${1:-"$( pwd )"}"
    rtcontrol -qO orphans.txt.default // -Ddir="${tgt}"
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
    local rtpath
    [[ -e "${1}" ]] && rtpath="$( _rt_path_selector "${1}" )" || rtpath=
    rtcontrol is_complete=y completed=+60s last_xfer=+6h ${rtpath} -qo'size.sz,ratio,seedtime,alias,name'
}

function rt-completed() {
    local rtpath
    [[ -e "${1}" ]] && rtpath="$( _rt_path_selector "${1}" )" || rtpath=
    rtcontrol is_complete=y completed=+60s ${rtpath} -qo'size.sz,ratio,seedtime,alias,name'
}

function rt-trackerannounce() {
    local rtselect_string
    rtselect_string="${@}"
    rtselect_string="${rtselect_string:-//}"
    # do not use exec directly
    #   rtcontrol ${rtselect_string} --exec "d.tracker_announce={{item.hash}}" --yes
    # because it spams the tracker server with requests, slow it down by sequential calls:
    rtcontrol ${rtselect_string} -qo'hash' | while read -r -d $'\n' mhash; do rtcontrol hash=$mhash --exec "d.tracker_announce={{item.hash}}" --yes; done
}

function rt-fix-bencoded-error() {
    rt-trackerannounce message=/.*Could.not.parse.bencoded.data.*/
}

rt-speed() {
    rtcontrol up=+0   -qo'up.sz'   --summary
    rtcontrol down=+0 -qo'down.sz' --summary
}

rt-size() {
    local rtselect_string
    rtselect_string="${@}"
    rtselect_string="${rtselect_string:-//}"
    rtcontrol ${rtselect_string} -qo'size.sz' --summary
}
