#!/bin/bash - 40's bashrc file

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# History file configuration
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="&:ls:[bf]g:exit:pwd:clear:date:* --help:man *:history*:[ \t]*"
HISTTIMEFORMAT="%F %T "

## expand the history size
HISTFILESIZE=10000
HISTSIZE=500

## fix cd mispellings, append to history file, and check window size recursively
shopt -s cdspell
shopt -s histappend
shopt -s checkwinsize

PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# default editor
set -o vim
export VISUAL=vim
export EDITOR="$VISUAL"

# make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# comment out to deactive colors and focus
force_color_prompt=yes

# Colored prompt
RED='\[\033[0;31m\]'
GREEN='\[\033[0;32m\]'
BLUE='\[\033[0;34m\]'
NC='\[\033[0m\]' # No Color

if [ "$color_prompt" = yes ]; then
    PS1="${GREEN}\u${NC}@${RED}\h${NC}:${BLUE}\w${NC}\\$ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi