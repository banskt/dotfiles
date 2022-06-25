#!/usr/bin/env bash

(return 0 2>/dev/null) && sourced=1 || sourced=0

#echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "BASH_SOURCE:" "$( dirname "${BASH_SOURCE[0]}" )"
echo "PWD:" "$( cd $(dirname "${BASH_SOURCE[0]}") && pwd )"

# Test if this script was run via the "dotfiles" bin script (vs. via curl/wget)
function is_dotfiles_bin() {
  bname=$( basename $0 )
  echo $bname
  [[ "$(basename $0 2>/dev/null)" == dotfiles ]] || return 1
}
echo "Check source of this script"
is_dotfiles_bin; echo $?
echo ".."
echo "Everything executed till here."
if [[ ${sourced} == 1 ]]; then
    echo "Source."
else
    echo "Execute."
fi

echo "The arguments are ${@}"

[[ "$sourced" == 1 ]] && return

echo "I will be executed"

