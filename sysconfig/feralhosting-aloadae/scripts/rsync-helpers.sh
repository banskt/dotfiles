#!/usr/bin/env bash

# ** DEPENDENCY **
#
# _filelog and SB_BASHLOG_FILE must be in path

# =================================================
# useful functions, snippets
# =================================================

# ashwini / feral can have dodgy connections
# ensure that the rsync works
# Example usage:
#     _ensure_rsync source_file ashwini:target_file
#     _ensure_rsync "source_file\ with\ spaces" "ashwini:target_file\ with\ spaces"
#
function _filelog_or_echo() {
    local msg
    msg="${@}"
    ( type -t _filelog > /dev/null ) && _filelog "${msg}" || echo "${msg}"
}

function _datefmt() {
    date +'%Y-%m-%d %H:%M:%S'
}

function _ensure_rsync() {
    local fsource
    local ftarget
    local retry_count
    local cmdstatus
    fsource="${1}"
    ftarget="${2}"
    retry_count=0
    while [ true ]
    do
        # somehow fails for escaped characters
        # rsync has a built in flag 
        # -s, --protect-args          no space-splitting; only wildcard special-chars
        # I can also directly set the user group and permissions from rsync
        # --chmod=D2774,F644 --chown=banskt:minion
        rsync -avz -s -q --partial --progress --append-verify --timeout=300 "${fsource}" "${ftarget}"
        cmdstatus=$?
        if [[ ${cmdstatus} -eq 0 ]]; then
            # rsync successful
            _filelog_or_echo "$( _datefmt ) : rsync success | ${fsource}"
            return 0
        else
            retry_count=$(( ${retry_count} + 1  ))
            _filelog_or_echo "$( _datefmt ) : rsync fail | ${fsource}"
            _filelog_or_echo "$( _datefmt ) : exit code ${cmdstatus} | backoff and retry ${retry_count}"
        fi
        sleep 5
    done
}

# do not rsync whole directory at once due to dodgy connection
# break stuff into single transfers,
# so it is easier to debug / restart if something goes wrong
#
function _ensure_recursive_rsync() {
    # take care of whitespace in directory name
    #printf -v target %q "${@}"
    # `find` does not require escaping
    # just put everything in quotes 
    # (otherwise `find` will escape the escaping characters,
    # (e.g. john\'s --> john\\'s)
    local sourcepath
    local remotepath
    sourcepath="${1%/}"
    remotepath="${2%/}"

    # the results of find can have white space, never loop over them
    # the following solution will still fail for newline characters in filename
    # but that is an extremely rare case
    #    https://stackoverflow.com/q/9612090
    if [[ -d "${sourcepath}" ]]; then
        dirname="$( basename "${sourcepath}" )"
        find "${sourcepath}/" -maxdepth 1 -mindepth 1 -print0 | while read -r -d $'\0' fpath
        do
            _ensure_rsync "${fpath}" "${remotepath}/${dirname}/"
        done
    else
        _ensure_rsync "${sourcepath}" "${remotepath}/"
    fi
}
