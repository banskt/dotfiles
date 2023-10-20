#!/usr/bin/env bash

_is_debug() {
    [[ "$DEBUG_FLAG" == 1 ]]   || return 1
}


_is_verbose() {
    [[ "$VERBOSE_FLAG" == 1 ]] || return 1
}


_is_fileout_possible() {
    if [[ ! -z "${SB_BASHLOG_FILE}" ]]; then
        { [[ -f "${SB_BASHLOG_FILE}" ]] || touch "${SB_BASHLOG_FILE}" > /dev/null 2>&1; } && return 0 || return 1
    else
        return 1
    fi
}


function _filelog() {
    local msg
    msg="${@}"
    if _is_fileout_possible; then
        #
        # print to stdout and file for interactive session
        if [[ $- == *i* ]]; then
            echo "${msg}" | tee -a "${SB_BASHLOG_FILE}"
        #
        # do not print to stdout for non-interactive session
        else
            echo "${msg}" >> "${SB_BASHLOG_FILE}"
        fi
    else
        echo "${msg}"
    fi
}


function _vlog() {
    # this function always returns True
    # call _filelog with a verbose flag
    { _is_verbose && _filelog "${@}"; } || return 0
}


function _dbglog() {
    # this function always returns True
    # this cannot go into the logfile because
    # we start debugging even before the logfile
    # is defined.
    { _is_debug && echo "${@}"; } || return 0
}
