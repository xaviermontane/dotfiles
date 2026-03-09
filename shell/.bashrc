# exit if non-interactive
[[ $- != *i* ]] && return

# environment variables
export EDITOR=nvim
PATH="$PATH:/usr/sbin:/sbin"

# history
HISTSIZE=50000 HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:cd:pwd:exit"
HISTTIMEFORMAT='%F %T '

shopt -s histappend
PROMPT_COMMAND="history -a; history -n"

# start-up
eval "$(starship init bash)"
command -v fastfetch >/dev/null && fastfetch

# with ♡ by 40
