# This is my version controlled .bash_aliases file 

###### Clear and List commands #####

alias cla="clear && ls -A"
alias cls="clear && ls"
alias cll="clear && ls -alF"
alias la="ls -A"
alias ll="ls -alF"
alias clc="clear"

##### mv and rm protection #####
alias mv="mv -i"
alias rm="rm -i"

##### MINGW64 Commands #####

# Open file explorer in current directory
alias files="explorer ." # For MINGW64
alias files="nautilus ." # For Ubuntu 18.04
alias files="explorer.exe ." # For WSL 2 Ubuntu 18.04
