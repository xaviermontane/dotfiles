#!/bin/bash - 40's bashrc file

[ -z "$PS1" ] && return

export PATH="$PATH:$HOME/.local/bin"
export PS1='\[\e[38;5;60m\]\t\[\e[38;5;21m\] [\[\e[38;5;92m\]\u\[\e[38;5;57m\]@\[\e[38;5;63m\]\h\[\e[38;5;21m\]] \[\e[38;5;123m\]\w\[\e[92m\]\$\[\e[0m\]'
force_color_prompt=yes

# History file configuration
export HISTFILE=/home/$USER/.config/bash/.bash_history
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="&:ls:[bf]g:exit:pwd:clear:date:* --help:man *:history*:[ \t]*"
HISTTIMEFORMAT="%F %T "

HISTFILESIZE=10000
HISTSIZE=500
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Fix cd mispellings, append to history file, and check window size recursively
shopt -s cdspell
shopt -s histappend
shopt -s checkwinsize

# Enable autocomplete
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

set mark-symlinked-directories on

# Default editor
set -o neovim
export VISUAL=neovim
export EDITOR="$VISUAL"

# Enable color for commands
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# List command after cd
cd() {
    builtin cd "$@" && ls -lA
}

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot (Debian specific)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Source local configs
if [ -f /.config ]; then
    . ~/.config/.dotfiles
fi

neofetch