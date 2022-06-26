#!/bin/bash

CWD=$(pwd)
SRCDIR=~/dotfiles
TARGET=~/.dotfiles

for mdir in 'bash'; do 
    mkdir -p ${TARGET}/${mdir}
    cd ${TARGET}/${mdir}
    for file in ${SRCDIR}/${mdir}/*.sh     ; do ln -s --force ${file} .; done
    for file in ${SRCDIR}/${mdir}/*.bashrc ; do ln -s --force ${file} .; done
    cd ${CWD}
done
