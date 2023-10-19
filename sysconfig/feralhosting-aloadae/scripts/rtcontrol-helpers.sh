#!/usr/bin/env bash

function rt-error() {
    local mycmd
    mycmd="${@}"
    rtcontrol -qo 'tracker,name' 'message=/.*Failure.*Unregistered.*/' ${mycmd}
}

function rt-orphan() {
    local cwd
    local tgt
    cwd=$( pwd )
    tgt="${1:-$cwd}"
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
function _rt_path_selector() {
    local fpath
    local escaped_fpath
    fpath=$( realpath "${1}" )
    escaped_fpath=$( printf '%q' "${fpath}" | sed 's/\\././g' )
    echo path='/^'"${escaped_fpath}"'.*$/'
}


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

#         x < 50MB  : 32kB 
# 50MB  < x < 150MB : 64kB
# 150MB < x < 350MB : 128kB
# 350MB < x < 512MB : 256kB
# 512MB < x < 1GB   : 512kB
# 1GB   < x < 2GB   : 1024kB
# 2GB   < x < 20GB  : 2048kB
# 20GB  < x         : 4096kB
# 
# Chunk size higher than 4MB is known to cause issues with rTorrent. 
# 
function _get_rt_chunk_size() {
    ## variables used
    local fname
    local fsize_arr
    local fsize
    local min_fsize
    local chunk_size
    #
    fname="${1}"
    fsize_arr=()
    if [[ -f "${fname}" ]]; then
        fsize=$( du -sh "${fname}" | cut -f1 | numfmt --from=iec )
        fsize_arr+=( "${fsize}" )
    else
        for f in "${fname}"/*; do
            fsize=$( du -sh "${f}" | cut -f1 | numfmt --from=iec )
            fsize_arr+=( "${fsize}" )
        done
    fi

    min_fsize="${fsize_arr[0]}"
    for i in "${fsize_arr[@]}"; do
        [[ ${i} -lt ${min_fsize} ]] && min_fsize=${i}
    done
    ## min_fsize_readable=$( echo ${min_fsize} | numfmt --to=iec )
    # convert filesize to MB
    fsize=$( echo "${min_fsize}" | awk ' {$1/=1048576; printf "%0.2f",$1} ' | cut -d'.' -f1)

    chunk_size="1024K"
    if [[ "${fsize}" -lt 50 ]]; then
        chunk_size="32K"
    elif [[ "${fsize}" -lt 150 ]]; then
        chunk_size="64K"
    elif [[ "${fsize}" -lt 350 ]]; then
        chunk_size="128K"
    elif [[ "${fsize}" -lt 512 ]]; then
        chunk_size="256K"
    elif [[ "${fsize}" -lt 1024 ]]; then
        chunk_size="512K"
    elif [[ "${fsize}" -lt 2048 ]]; then
        chunk_size="1024K"
    elif [[ "${fsize}" -lt 20480 ]]; then
        chunk_size="2048K"
    else
        chunk_size="4096K"
    fi

    echo ${chunk_size}
}


_get_rt_chunk_length() {
    local size
    local length
    size=$( numfmt --from=iec "${1}" )
    length=$( echo "l($size)/l(2)" | bc -l | cut -d'.' -f1 )
    echo "${length}"
}
