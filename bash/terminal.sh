#!/bin/bash

# show all available bash colors on the terminal
#   $ show-bash-colors
function show-bash-colors() {
    for fgbg in 38 48 ; do # Foreground / Background
        for color in {0..255} ; do # Colors
            # Display the color
            printf "\e[${fgbg};5;%sm  %3s  \e[0m" $color $color
            # Display 6 colors per lines
            if [ $((($color + 1) % 20)) ==  0 ] ; then
                echo # New line
            fi
        done
        echo # New line
    done
}

# Set the title string at the top of terminal window tab
# https://unix.stackexchange.com/questions/177572/how-to-rename-terminal-tab-title-in-gnome-terminal/566383#566383
set-terminal-title() {
    CMD="set-terminal-title"
    # Help menu
    if [ "$1" == "-h" ] || [ "$1" == "-?" ]; then
        echo "Set the title of your currently-opened terminal tab."
        echo "Usage:   $CMD any title you want"
        echo "   OR:   $CMD \"any title you want\""
        echo "   OR (to make a dynamic title which relies on variables or functions):"
        echo "         $CMD '\$(some_cmd)'"
        echo "     OR  $CMD '\${SOME_VARIABLE}'"
        echo "Examples:"
        echo "         1. static title"
        echo "           $CMD my new title"
        echo "         2. dynamic title"
        echo "           $CMD 'Current Directory is \"\$PWD\"'"
        echo "       OR  $CMD 'Date and time of last cmd is \"\$(date)\"'"
        return $EXIT_SUCCESS
    fi
    # If the length of string stored in variable `PS1_BAK` is zero...
    # - See `man test` to know that `-z` means "the length of STRING is zero"
    if [[ -z "$PS1_BAK" ]]; then
        # Back up your current Bash Prompt String 1 (`PS1`) into a global backup variable `PS1_BAK`
        PS1_BAK=$PS1
    fi

    # Set the title escape sequence string with this format: `\[\e]2;new title\a\]`
    # - See: https://wiki.archlinux.org/index.php/Bash/Prompt_customization#Customizing_the_terminal_window_title
    TITLE="$@"
    ESCAPED_TITLE="\[\e]2;${TITLE}\a\]"
    # Delete any existing title strings, if any, in the current PS1 variable.
    # https://askubuntu.com/questions/1310665/how-to-replace-terminal-title-using-sed-in-ps1-prompt-string
    PS1_NO_TITLE="$(echo "$PS1" | sed 's|\\\[\\e\]2;.*\\a\\\]||g')"
    # Now append the escaped title string to the end of your original `PS1` string (`PS1_BAK`), and set your
    # new `PS1` string to this new value
    PS1="${PS1_NO_TITLE}${ESCAPED_TITLE}"
}

# Set a fancy bash prompt (non-color, unless we know we "want" color)
#
# see https://misc.flogisoft.com/bash/tip_colors_and_formatting
# for 256 colors, the color format is
#   \e[${attr};38;5;${cnum}m (foreground)
#   \e[${attr};48;5;${cnum}m (background)
# where ${attr} is the code for font attribute
# 0 = normal, 1 = bold, 2 = dim, 3 = italics, 4 = underlined,
# 5 = blink, 7 = reverse, 8 = hidden (think passwords)
# and ${cnum} is the color number.
# I have defined a function below to see all the color numbers:
#   $ show-bash-colors
# Here is an example:
#   $ echo -e "\e[1;38;5;229mHello \e[1;48;5;229;38;5;232mWorld\e[0m"
# Note the second format is \e[${attr};${background};${foreground}m"
#
# Non-printable sequences should be enclosed in \[ and \]
# see https://unix.stackexchange.com/questions/105958/terminal-prompt-not-wrapping-correctly
function set-bash-prompt() {
    # is there color support?
    case "$TERM" in
        xterm-color|*-256color) color_prompt=yes;;
    esac
    FRED="\[\e[0;38;5;9m\]"
    FBLE="\[\e[0;38;5;69m\]"
    FYEL="\[\e[0;38;5;3m\]"
    FGRN="\[\e[0;38;5;70m\]"
    RESET="\[\e[0m\]"
    if [ "$color_prompt" = yes ]; then
        PS1="$FRED${debian_chroot:+($debian_chroot)}$FBLE\t $FYEL[\u@\h] $FGRN\W $FBLE\$ $RESET"
    else
        PS1='${debian_chroot:+($debian_chroot)}\t [\u@\h] \W \$ '
    fi
    unset color_prompt force_color_prompt
}

set-bash-prompt
set-terminal-title '$( hostname ): $( pwd )'

# Utilities from Ubuntu bashrc
#
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
