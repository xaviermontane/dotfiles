#! usr/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Identify the chroot (Debian specific)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Environment variables
export EDITOR=neovim
export PATH="$PATH:/usr/sbin:/sbin"

# Prompt customization
export PS1='\[\e[35m\]\u\[\e[0m\]@\[\e[95m\]\h\[\e[0m\]:\[\e[36m\]\w\[\e[32m\][\e[0m\]\$ '
force_color_prompt=yes

# History file configuration
export HISTFILE=/$HOME/.bash_history
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="&:ls:[bf]g:exit:pwd:clear:date:* --help:man *:history*:[ \t]*"
HISTTIMEFORMAT="%F %T "
HISTFILESIZE=9999
HISTSIZE=499
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Shell behavior
shopt -s cdspell
shopt -s histappend
shopt -s checkwinsize

# Enable autocomplete
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

set mark-symlinked-directories on

# Enable command coloring
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Source configurations
if [ -f ~/.config/shell/.bashrc ]; then
    . ~/.config/shell/.bashrc
fi
.
if [ -f ~/.config/shell/.aliases ]; then
    . ~/.config/shell/.aliases
fi

# Miscellaneous
eval "$(starship init bash)"
fastfetch

# with ♡ by 40
