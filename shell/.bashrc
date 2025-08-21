#!/usr/bin/env bash

# Exit if not interactive
[[ $- != *i* ]] && return

# Core environment
export EDITOR=vim
export PATH="$PATH:/usr/sbin:/sbin"

# Autocompletion
[[ -f /etc/bash_completion ]] && . /etc/bash_completion

# Colors & LS aliases
if command -v dircolors &>/dev/null; then
    eval "$(dircolors)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# Starship prompt
eval "$(starship init bash)"

# Extras
neofetch

# with ♡ by 40
