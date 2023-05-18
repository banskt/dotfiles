#!/usr/bin/env bash

#test-variable() { [[ -z "${1}" ]] && echo "unset or empty" || echo "${1}"; }
#test-unset() { [[ -z "${1+bar}" ]] && echo "unset" || echo "${1+bar}"; }
#test-empty() { [[ -z "${1-bar}" ]] && echo "empty" || echo "${1-bar}"; }

#VAR="something"
#VAR=""
#unset VAR

test-variable() {
    [[ -z "${1}" ]]     && echo "empty or unset" || echo ${1}
    [[ -z "${1+foo}" ]] && echo "unset"          || echo ${1+foo}
    [[ -z "${1-foo}" ]] && echo "empty"          || echo ${1-foo}
}

echo "Truth: VAR is something"
VAR="something"
[[ -z "${VAR}" ]]     && echo "empty or unset" || echo ${VAR}
[[ -z "${VAR+foo}" ]] && echo "unset"          || echo ${VAR+foo}
[[ -z "${VAR-foo}" ]] && echo "empty"          || echo ${VAR-foo}
echo "Function:"
test-variable $VAR
echo ""

echo "Truth: VAR is empty"
VAR=""
[[ -z "${VAR}" ]]     && echo "empty or unset" || echo ${VAR}
[[ -z "${VAR+foo}" ]] && echo "unset"          || echo ${VAR+foo}
[[ -z "${VAR-foo}" ]] && echo "empty"          || echo ${VAR-foo}
echo "Function:"
test-variable $VAR
echo ""


echo "Truth: VAR is unset"
unset VAR
[[ -z "${VAR}" ]]     && echo "empty or unset" || echo ${VAR}
[[ -z "${VAR+foo}" ]] && echo "unset"          || echo ${VAR+foo}
[[ -z "${VAR-foo}" ]] && echo "empty"          || echo ${VAR-foo}
echo "Function:"
test-variable $VAR
echo ""




#if [[ -z "${VAR}" ]]; then
#    echo "VAR is unset or set to the empty string"
#fi
#if [[ -z "${VAR+foo}" ]]; then
#    echo "VAR is unset"
#fi
#if [[ -z "${VAR-foo}" ]]; then
#    echo "VAR is set to the empty string"
#fi
#if [[ -n "${VAR}" ]]; then
#    echo "VAR is set to a non-empty string"
#fi
#if [[ -n "${VAR+foo}" ]]; then
#    echo "VAR is set, possibly to the empty string"
#fi
#if [[ -n "${VAR-foo}" ]]; then
#    echo "VAR is either unset or set to a non-empty string"
#fi
