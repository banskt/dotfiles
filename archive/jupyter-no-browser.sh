#!/bin/bash

PIDFILE="save_pid.txt"
LOGFILE="jupyter_log.txt"
PORT=8988
CMD="jupyter notebook --no-browser --port ${PORT}"

SILENT="false"
if [[ ! -z $2 ]]; then
    if [[ $2 == 'silent' ]]; then
        SILENT="true"
    fi
fi

function show_running() {
    PROCID=$( ps ux | grep "[j]upyter-notebook --no-browser" | awk '{print $2}' )
    if [[ ! -z ${PROCID} ]]; then
        # show the information for processes
        # -f   full-format listing.
        # -F   extra full-format
        # -l   long format (extra fields)
        # -ww  Wide output.  Use this option twice for unlimited width.
        ps -fww -p ${PROCID}
    fi
}

if [[ $1 == "start" ]]; then
    # check if Jupyter is already running
    # _isRunning=$( ps aux | grep -i "jupyter-notebook --no-browser" | grep -v "grep" | grep ${USER} )
    # prevent 'grep' showing up in ps result
    # https://unix.stackexchange.com/questions/74185/
    _isRunning=$( ps ux | grep "[j]upyter-notebook --no-browser")
    if [ ! -z "${_isRunning}" ]; then
	    echo "Jupyter notebook is already running."
        show_running
    else
        source ~/.bashrc
        load-env
        ${CMD} > ${LOGFILE} 2>&1 &
        echo $! > ${PIDFILE}
        while :
        do
            if [[ -f "${LOGFILE}" ]]; then
                break
            fi
            echo "Waiting for Jupyter to start ..."
            sleep 1
        done
        REMOTE_URI=
        while [ -z "${REMOTE_URI}" ]; do
            REMOTE_URI=$( cat ${LOGFILE} | grep "\/\?token=" | awk '{print $NF}' | head -n 1 )
            echo "Waiting for Jupyter to start ..."
            sleep 1
        done
        echo "Started Jupyter at ${REMOTE_URI}"
    fi
fi

if [[ $1 == "stop" ]]; then
    if [ -f ${PIDFILE} ]; then
        echo "Killing Jupyter Notebook."
        kill -9 $( cat ${PIDFILE} )
        rm ${PIDFILE}
    else
        echo "No PID found for Jupyter Notebook."
    fi
    if [ -f ${LOGFILE} ]; then
        echo "Removing log file."
        rm ${LOGFILE}
    else
        echo "No log file found for Jupyter Notebook."
    fi
fi

if [[ $1 == "kill" ]]; then
    show_running
    PROCID=$( ps ux | grep "[j]upyter-notebook --no-browser" | awk '{print $2}' )
    if [[ -z ${PROCID} ]]; then
        echo "No jupyter is running. Nothing to kill."
    fi
    for PID in ${PROCID}; do
        if [[ ${SILENT} != "true" ]]; then
            echo "Kill process ${PID}?"
            read CONFIRM
            if [[ ${CONFIRM} =~ ^[yY]$ || ${CONFIRM} =~ ^[yY][eE][sS]$ ]]; then
                echo "Killing process ${PID}"
                kill -9 ${PID}
            fi
        else
            echo "Killing process ${PID}"
            kill -9 ${PID}
        fi
    done
fi
