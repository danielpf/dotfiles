# Set up the prompt
autoload -Uz promptinit
promptinit
prompt adam2

# ------ HISTORY
setopt histignorealldups # remove consecutive duplicates
setopt sharehistory
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
export HISTSIZE=5000
export SAVEHIST=5000
export HISTFILE=~/.zsh_history

# ------ KEYS
# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# ------ AUTO COMPLETION
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

setopt automenu
setopt nolisttypes

# ------ DIRS
setopt AUTO_CD # cd for lazy people


# create directory structure and cd into it
function mkcdir() {
  mkdir -p -- "$1" && cd -P -- "$1"
}

function chpwd() {
    emulate -L zsh
    printf "$PWD/:\n"
    ls --group-directories-first
}

# ------

export EDITOR="nvim"
export GPG_TTY=$(tty)
export MANPAGER="less -X" # Don't clear the screen after quitting a manual page

function cfg() {
  GIT_CONFIG=$HOME/.gitcfgconfig /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME "$@"
}
function cfg_push() {
  pushd
  cfg add .
  cfg add .config/nvim
  cfg commit -m "auto"
  cfg push --set-upstream origin master
  popd
}

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

if [ -f $HOME/.cargo/env ]; then
  . $HOME/.cargo/env
fi

if [ -f $HOME/.zoxide.sh ]; then
. $HOME/.zoxide.sh
fi

if [ -f $HOME/.alias.sh ]; then
  . $HOME/.alias.sh
fi
