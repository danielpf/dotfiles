# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam2

# ------ HISTORY
setopt histignorealldups sharehistory
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# ------ KEYS

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# ------ DIRS

setopt AUTO_CD

alias ls='ls --color'
alias ll='ls --color -alF --human-readable'
alias la='ls --color -A'
alias l='ls --color -CF'

alias c="cd"

# create directory structure and cd into it
function mkcdir() {
  mkdir -p -- "$1" && cd -P -- "$1"
}

function chpwd() {
    emulate -L zsh
    printf "$PWD/:\n"
    ls --group-directories-first
}

alias rm="rm -i"

# ------ 

export PATH=~/.local/bin:$PATH
export PATH=~/myscripts:$PATH
export PATH=~/bin:$PATH
# Ruby:
export PATH="$PATH:$HOME/.rvm/bin"

export EDITOR="nvim"
export GPG_TTY=$(tty)
export MANPAGER="less -X" # Don't clear the screen after quitting a manual page

alias cfg="GIT_CONFIG=$HOME/.gitcfgconfig /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

alias vim="nvim"
alias vhome="vim ~"
alias vhere="nvim ."
alias v"nvim ."
alias vzshrc="nvim ~/.zshrc"

alias ip="ip -c"
alias df="df -h"
alias free="free -m"

# man pages colour configuration
# https://www.tuxarena.com/2012/04/tutorial-colored-man-pages-how-it-works/
#
export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode – red
export LESS_TERMCAP_md=$(printf '\e[01;33m') # enter double-bright mode – bold, yellow
export LESS_TERMCAP_me=$(printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode – yellow
export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;31m') # enter underline mode – red

# -----


