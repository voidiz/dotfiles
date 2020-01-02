# Environment variables
export ZDOTDIR="$HOME/.zsh"
export FPATH="$FPATH:$HOME/.zsh/pure"

# Set prompt
autoload -U promptinit; promptinit
zstyle :prompt:pure:path color magenta
prompt pure

# Set exa colors
source $HOME/.vim/plugged/falcon/exa/EXA_COLORS

# Set up Node Version Manager
# source /usr/share/nvm/init-nvm.sh

# Aliases
alias vim="NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim"
alias n="nnn"
alias ..="cd .."
alias ls="exa"

# History
HISTFILE=~/.zsh/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob

# Vi-mode editing
bindkey -v

# Extended completion
zstyle :compinstall filename "$HOME/.zsh/.zshrc"
autoload -Uz compinit; compinit
