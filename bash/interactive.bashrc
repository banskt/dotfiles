#!/bin/bash

# Import all interactive plugins
dotsrc ${DOTFILES}/bash/interactive

# Set prompt
my-bash-prompt
set-terminal-title '$(hostname):  $(pwd-short)'

# enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -lhF --group-directories-first'
alias lla='ls -AlhF --group-directories-first'
alias lsc='ls -ACF --group-directories-first'

# create a desktop notification alert.  Use like so:
#     sleep 1; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# module specific loadings
for dir in python git; do
    dotsrc ${DOTFILES}/${dir}
done
