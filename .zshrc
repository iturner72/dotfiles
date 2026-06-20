# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# Add $HOME/bin to path
export PATH="$HOME/bin:$PATH"

# Python stuff
export PATH="$HOME/.local/bin:$PATH"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Rust/Cargo (only if you have it installed)
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Fzf settings
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_DEFAULT_OPTS="--no-mouse --height 80% -1 --reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),I:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy)'"

# Git branch in prompt
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Prompt (zsh uses different syntax)
setopt PROMPT_SUBST
PROMPT='%F{magenta}%n%f %F{cyan}%~%f %F{red}$(parse_git_branch)%f $ '

# Aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# tmux layout
# dev [dir]                     -> editor over shell 
# dev [serverdir] [clientdir]   -> server col + client col
dev() {
    local ldir rdir name
    ldir="$(cd "${1:-$PWD}" 2>/dev/null && pwd)" || { echo "no such dir: $1"; return 1; }
    name="$(basename "$ldir" | tr '.: ' '___')"  # session names can't contain . or :
    [ -n "$2" ] && { rdir="$(cd "$2" 2>/dev/null && pwd)" || { echo "no such dir: $2"; return 1; }; }

    if ! tmux has-session -t "=$name" 2>/dev/null; then
        tmux new-session  -d -s "$name" -c "$ldir" -n main
        tmux send-keys    -t "$name" 'nvim .' C-m
        if [ -n "$rdir" ]; then
            tmux split-window -h -l 50% -t "$name" -c "$rdir"   # right col: client editor
            tmux send-keys    -t "$name" 'nvim .' C-m
            tmux split-window -v -l 50% -t "$name" -c "$rdir"   # bottom-right: client shell
            tmux select-pane  -t "$name" -L                     # back to left column
            tmux split-window -v -l 50% -t "$name" -c "$ldir"   # bottom-left: server shell
            tmux select-pane  -t "$name" -U                     # focus server editor
        else
            tmux split-window -v -l 50% -t "$name" -c "$ldir"
            tmux select-pane  -t "$name" -U
        fi
    fi

    if ! tmux has-session -t "=$name" 2>/dev/null; then
        tmux new-session -d -s "$name" -c "$dir" -n main
        tmux send-keys   -t "$name" 'nvim .' C-m
        tmux split-window -v -l 50% -t "$name" -c "$dir"
        tmux select-pane -U -t "$name"
    fi

    # switch if already in tmux, otherwise attach
    [ -n "$TMUX" ] && tmux switch-client -t "$name" || tmux attach -t "$name"
}

# Secret environment variables
[ -f ~/.secret_env ] && source ~/.secret_env

# Local bin env
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Git completion (zsh has built-in git completion, but if you have custom one)
[ -f ~/.git-completion.zsh ] && source ~/.git-completion.zsh

# postgres 
export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/postgresql@18/lib"
export CPPFLAGS="-I/opt/homebrew/opt/postgresql@18/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/postgresql@18/lib/postgresql/pkgconfig:$PKG_CONFIG_PATH"


