#!/bin/bash

# get the absolute path of directory of a file, 
# particularly useful to know the location of a running script:
#     dir_path "${BASH_SOURCE[0]}"
function dir_path() {
    echo "$( cd "$( dirname "${1}" )" >/dev/null 2>&1 && pwd )"
}

# get absolute path for any given path
function abs_path() {
    # $1: relative path
    echo "$(dir_path "${1}")/$(basename "${1}")"
}
