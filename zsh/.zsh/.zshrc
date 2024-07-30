# Environment variables
export ZDOTDIR="$HOME/.zsh"
export FPATH="$FPATH:$HOME/.zsh/pure"
export EDITOR=nvim
export VISUAL=nvim
export PATH="$PATH:$HOME/.local/bin:$HOME/go/bin:$HOME/.cargo/bin"

# Set prompt
autoload -U promptinit; promptinit
zstyle :prompt:pure:path color magenta
prompt pure

# Set up Node Version Manager
# source /usr/share/nvm/init-nvm.sh --no-use
# Set up Fast Node Manager
export PATH="$HOME/.local/share/fnm:$PATH"
eval "`fnm env`"

# Aliases
alias vim="nvim"
alias ..="cd .."
alias ls="eza --hyperlink"
alias ssh="kitty +kitten ssh" # terminfo fix
alias synk="rsync -avhP --info=progress2" # archive, verbose, human, partial
alias dnd="dragon-drop"
alias rg="rg --hyperlink-format=kitty"
alias ndiff="nvim -d"

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

# rsync files to Android movies folder (using sshelper)
# $1 is src, $2 is ip
asynk() {
    synk -e 'ssh -p2222' $1 $2:SDCard/Movies
}

# History
HISTFILE=~/.zsh/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob

# Don't add to histfile if prefixed with space
setopt HIST_IGNORE_SPACE

# Search history with prefix
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search
bindkey -M vicmd 'k' up-line-or-beginning-search

# Vi-mode editing
bindkey -v

# Search history with Ctrl+R
bindkey "^R" history-incremental-search-backward

# Match extensions using glob, main completer, match others when nothing found
zstyle ':completion:*' completer _extensions _complete _approximate

# Try exact case, then try ignore case. Finally, try substrings.
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Use completion menu
zstyle ':completion:*' menu select

# Styling
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Group results
zstyle ':completion:*' group-name ''

# Navigate results using hjkl
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Source completion files (e.g., _docker)
fpath=($fpath $ZDOTDIR/completions)

# Enable extended completion
zstyle :compinstall filename "$HOME/.zsh/.zshrc"
autoload -Uz compinit; compinit

# opam configuration
[[ ! -r $HOME/.opam/opam-init/init.zsh ]] || source $HOME/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

