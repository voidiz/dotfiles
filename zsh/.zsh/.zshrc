# Environment variables
export ZDOTDIR="$HOME/.zsh"
export FPATH="$FPATH:$HOME/.zsh/pure"
export EDITOR=nvim

# Set prompt
autoload -U promptinit; promptinit
zstyle :prompt:pure:path color magenta
prompt pure

# Set up Node Version Manager
# source /usr/share/nvm/init-nvm.sh

# Aliases
alias vim="NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim"
alias ..="cd .."
alias ls="exa"

# nnn configuration (use n instead of nnn)
n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

# c++: Compile and run the supplied file with
# all inputs *.in in the cwd
ccc() {
    g++ -std=c++17 -O2 -g -Wall -pedantic "$@"
    for file in *.in; do
        echo "Input $file:"
        ./a.out < "$file"; echo -e
    done
}

# History
HISTFILE=~/.zsh/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob

# Vi-mode editing
bindkey -v

# Search history with Ctrl+R
bindkey "^R" history-incremental-search-backward

# Extended completion
zstyle :compinstall filename "$HOME/.zsh/.zshrc"
autoload -Uz compinit; compinit
# Ignore case matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
