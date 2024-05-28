# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi


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
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# some conditional aliases to open file explorer and nautilus
if [ -d /mnt/c/Windows ]; then
    alias files="explorer.exe ."
else
    alias files="nautilus ."
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# add $HOME/bin to path for personal bash scripts
export PATH="$HOME/bin:$PATH"

# Fzf things
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_DEFAULT_OPTS="--no-mouse --height 80% -1 --reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),I:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy)'"

# Since this .bashrc is used on both wsl and a normal Ubuntu 18.04 distibution
# I will try and make an if statement to export the correct paths to the
# correct environments. This has been modified to accomodate my work computer.

if [ -d /mnt/c/Users/imturner ]; then
    export PATH=/usr/local/texlive/2023/bin/x86_64-linux:$PATH
elif [ -d /mnt/c/Windows ]; then
    export PATH=/usr/local/texlive/2023/bin/x86_64-linux:$PATH
else
#    export PATH=$PATH:$HOME/software/ardupilot/Tools/autotest
#    export ROS_PACKAGE_PATH=/home/ian/catkin_ws/src:/home/ian/lm_project/src:/opt/ros/melodic/share:$ROS_PACKAGE_PATH
#    source /usr/share/gazebo/setup.sh
#    export GAZEBO_MODEL_PATH=~/software/ardupilot_gazebo/models
fi

# fzf ctrl-r history keybinds
if [ -d /mnt/c/Users/imturner ]; then
source /usr/share/doc/fzf/examples/key-bindings.bash
source /usr/share/doc/fzf/examples/completion.bash
fi

# ROS package stuff
#export PATH=/usr/lib/ccache:$PATH

# CUDA environemt
export PATH=/usr/local/cuda-12.2/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}


# Parse Git branch function
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Check the operating system
case "$(uname -s)" in
    Linux*)
        if [ -f /etc/arch-release ]; then
            # Arch Linux
            color_prompt=yes
        elif [ -f /etc/debian_version ]; then
            # Debian-based systems
            if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
                debian_chroot=$(cat /etc/debian_chroot)
            fi
            color_prompt=yes
        else
            # Other Linux distributions
            color_prompt=yes
        fi
        ;;
    Darwin*)
        # macOS
        color_prompt=yes
        eval "$(/opt/homebrew/bin/brew shellenv)"
        . "$HOME/.cargo/env"
        ;;
    *)
        # Unknown operating system
        color_prompt=
        ;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;35m\]\u\[\033[00m\] \[\033[01;36m\]\w\[\033[00m\] \[\033[01;31m\]$(parse_git_branch)\[\033[00m\] $ '
else
    PS1='\u \w $(parse_git_branch)\ $ '
fi
unset color_prompt

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# WSL fix green directories
shopt -s extglob
LS_COLORS=${LS_COLORS/:ow=*([^:]):/:ow=:}

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/eze/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/eze/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/eze/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/eze/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH=~/miniconda3/bin:$PATH
export PATH=/opt/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH


