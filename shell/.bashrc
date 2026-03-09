# exit if non-interactive
[[ $- != *i* ]] && return

# environment
command -v nvim >/dev/null && export EDITOR=nvim || export EDITOR=vim

pathadd () { case ":$PATH:" in *":$1:"*) ;; *) PATH="$PATH:$1";; esac }
pathadd /usr/sbin
pathadd /sbin
unset -f pathadd

# aliases
[ -f ~/.aliases ] && source ~/.aliases

# functions
[ -f ~/.functions ] && source ~/.functions

# history
HISTSIZE=50000 HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:cd:pwd:exit:clear:history"
HISTTIMEFORMAT='%F %T '

shopt -s histappend

# lazy load starship
__init_starship() {
    unset -f __init_starship
    eval "$(starship init bash)"
}

PROMPT_COMMAND='history -a; history -n; __init_starship'

# system info banner
command -v fastfetch >/dev/null && [[ $SHLVL -eq 1 && $TERM != dumb ]] && fastfetch

# with ♡ by 40
