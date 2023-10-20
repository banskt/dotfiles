#!/usr/bin/env bash

function _entropy_hash() {
	printf "%0128s" "$( openssl rand -hex 64 )"
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


function _btn_announce_from_config() {
	# Do not export the variables
	bash -c '[[ -f "${HOME}/btn-autopack.cfg" ]] && { source "${HOME}/btn-autopack.cfg"; echo ${BTN_ANNOUNCE}; }'
}


function _btn_mktorrent() {
	local metapath
	local datapath
	local announce_url
	local lchunk
	metapath="$( realpath "${1}" )"
	datapath="$( realpath "${2}" )"
	announce_url="${3}"
	# Housekeeping
	# if announce_url is not provided, 
    # try to grab it from configuration file.
    if [[ -z "${announce_url}" ]]; then
		announce_url="$( _btn_announce_from_config )"
		[[ -z "${announce_url}" ]] && { echo "Could not find announce url."; exit 1; }		
	fi
    ## DEBUG ONLY
    ## echo "Metapath: ${metapath}"
    ## echo "Datapath: ${datapath}"
    ## echo "Announce URL: ${announce_url}"
	[[ -f "${metapath}" ]] && rm -f "${metapath}"
	# we can use mktor but mktorrent is faster and multi-threaded
	lchunk="$( _get_rt_chunk_length "$( _get_rt_chunk_size "${datapath}" )" )"
	mktorrent --announce="${announce_url}" \
	          --private \
              --threads=16 \
              --piece-length="${lchunk}" \
              --comment=BTN \
              --output="${metapath}" \
              "${datapath}"
	# add BTN information and fastresume information
	chtor --quiet \
          -s info.source=BTN \
          -s info.entropy="$( _entropy_hash )" \
          --no-cross-seed \
          --fast-resume="${datapath}" \
 	      "${metapath}"
}
