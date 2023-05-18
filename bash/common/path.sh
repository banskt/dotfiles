#!/usr/bin/env bash

# get the absolute path of directory of a file, 
# particularly useful to know the location of a running script:
#     dir_path "${BASH_SOURCE[0]}"
function dir_path() {
    if [ -d ${1} ]; then 
        echo "$( cd "${1}" >/dev/null 2>&1 && pwd )"
    elif [ -f ${1} ]; then
        echo "$( cd "$( dirname "${1}" )" >/dev/null 2>&1 && pwd )"
    else
        echo "No such file or directory."
        return 1
    fi
}

# get absolute path for any given path
function abs_path() {
    # $1: relative path
    if [ -d ${1} ]; then
        dir_path "${1}"
    elif [ -f ${1} ]; then
        echo "$(dir_path "${1}")/$(basename "${1}")"
    else
        echo "No such file or directory."
        return 1
    fi
}

# move up n directories
function up() {
    local d=""
    limit=${1}
    for ((i=1 ; i <= limit ; i++)); do
        d=${d}/..
    done
    d=$(echo ${d} | sed 's/^\///')
    if [ -z "${d}" ]; then
        d=..
    fi
    cd ${d}
}
