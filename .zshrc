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

# Secret environment variables
[ -f ~/.secret_env ] && source ~/.secret_env

# Local bin env
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Git completion (zsh has built-in git completion, but if you have custom one)
[ -f ~/.git-completion.zsh ] && source ~/.git-completion.zsh
