#!/usr/bin/env bash

# loaded by interactive.bashrc

# Clean Python __pycache__ and .pyc files
function pyclean() {
    find . -regex '^.*\(__pycache__\|\.py[co]\)$' -delete
}

function pydevclean() {
    __package=${1}
    if [[ ! -z ${__package} ]]; then
        __cwd=$( pwd )
        __dirname=$( basename ${__cwd} )
        #if [ ${__package} == ${__dirname} ]; then
        if [[ -d ./src/${__package} ]]; then
            pip uninstall -y ${__package}
            echo "Removing local build, egg-info and dynamic libraries."
            find . -name "*lib${__package}*.so" -delete
            find . -path "./src/${__package}.egg-info*" -delete
            find . -path "./build*" -delete
        else
            echo "This commands need to be run from parent directory."
        fi
    else
        echo "Please specify package name"
    fi
}
