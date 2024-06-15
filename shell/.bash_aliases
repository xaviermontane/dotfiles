# ~/.bash_aliases - 40's bash shell aliases and functions
#
#  sourced from ~/.bashrc

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


alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'

# directory navigation
alias ..='cd ..;pwd'
alias ...='cd ../..;pwd'
alias ....='cd ../../..;pwd'

# better tree
alias tree='tree --dirsfirst -F'

# 40 functions
cd() {
    builtin cd "$@" && ls -lA
}