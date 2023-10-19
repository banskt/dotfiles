#!/usr/bin/env bash

_is_debug() {
    [[ "$DEBUG_FLAG" == 1 ]]   || return 1
}


_is_verbose() {
    [[ "$VERBOSE_FLAG" == 1 ]] || return 1
}


function _filelog() {
    local msg
    msg="${@}"
    if [[ ! -z "${SB_BASHLOG_FILE}" ]]; then
        echo "${msg}" | tee -a "${SB_BASHLOG_FILE}"
    else
        echo "${msg}"
    fi
}


function _vlog() {
    # this function always returns True
    { _is_verbose && _filelog "${@}"; } || return 0
}


function _dbglog() {
    # this function always returns True
    # this cannot go into the logfile because
    # we start debugging even before the logfile
    # is defined.
    { _is_debug && echo "${@}"; } || return 0
}
