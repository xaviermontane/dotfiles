# ~/.bash_aliases - 40's bash shell aliases and functions
#    sourced from ~/.bashrc

# ====================================================== #
#                                                        #
#           888 d8b                                      #
#           888 Y8P                                      #
#           888                                          #
#   8888b.  888 888  8888b.  .d8888b   .d88b.  .d8888b   #
#      "88b 888 888     "88b 88K      d8P  Y8b 88K       #
#  .d888888 888 888 .d888888 "Y8888b. 88888888 "Y8888b.  #
#  888  888 888 888 888  888      X88 Y8b.          X88  #
#  "Y888888 888 888 "Y888888  88888P'  "Y8888   88888P'  #
#                                                        #
# ====================================================== #

# Bash aliases
alias .='cd .'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias bashclear='echo "" > ~/.bash_history'
alias clr='clear'
alias ls='ls -F --show-control-chars'
alias ll='ls -l'
alias ll.='ls -la'
alias lls='ls -la --sort=size'
alias llt='ls -la --sort=time'
alias rm='rm -iv'
alias code='cd ~/code;ls'
alias tree='tree --dirsfirst -F'

# Git aliases
alias gs='git status -sb'
alias gcc='git checkout'
alias gcm='git checkout main'
alias gaa='git add --all'
alias gc='git commit -m $2'
alias push='git push'
alias gpo='git push origin'
alias pull='git pull'
alias clone='git clone'
alias stash='git stash'
alias pop='git stash pop'
alias ga='git add'
alias gb='git branch'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gm='git merge'