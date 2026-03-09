# exit if non-interactive
[[ $- != *i* ]] && return

# environment
command -v nvim >/dev/null && export EDITOR=nvim || export EDITOR=vim

case ":$PATH:" in
  *:/usr/sbin:*) ;;
  *) PATH="$PATH:/usr/sbin:/sbin" ;;
esac

# history
HISTSIZE=50000 HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:cd:pwd:exit:clear:history"
HISTTIMEFORMAT='%F %T '

shopt -s histappend
PROMPT_COMMAND="history -a; history -n"

# start-up
eval "$(starship init bash)"
[[ $TERM != "dumb" ]] && command -v fastfetch >/dev/null && fastfetch

# with ♡ by 40
