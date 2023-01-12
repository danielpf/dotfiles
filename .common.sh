#!/bin/sh

# cursor color
echo -ne "\e]12;#F37A00\a"

# See /usr/share/doc/bash-doc/examples in the bash-doc package.
#
if [ -f ~/token ]; then
  export NPM_TOKEN=$(cat ~/token)
else
  if [ -z "$NPM_TOKEN" ]; then
    echo "missing NPM_TOKEN"
    export NPM_TOKEN=""
  fi
fi

export GPG_TTY=$(tty) # gpg needs this

function cfg() {
  # GIT_DIR ? GIT_WORK_TREE ? in nvim?
  GIT_CONFIG_GLOBAL=$HOME/.gitcfgconfig /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME "$@"
}
function cfg_push() {
  pushd
  cfg add .
  cfg add .config/nvim
  cfg commit -m "auto"
  cfg push --set-upstream origin master
  popd
}
function cfg_add() {
  cfg add .
  cfg add .config/nvim
}

function set_windows_terminal_title() {
  echo -ne "\033]0;$1\a"
}
function set_windows_terminal_title_to_hostname() {
  host=$((if hostname | grep -E 'EPESM.*'; then echo "WSL"; else hostname; fi) | cut -c1-20)
  last_command=$(!:0)
  set_windows_terminal_title "$host"
}

export PATH=$HOME/.local/bin/:$PATH
export PATH=$HOME/.yarn/bin/:$PATH
export PATH="$PATH:$HOME/.rvm/bin" # Ruby
export PATH=$HOME/scripts/bin:$PATH
export PATH='node_modules/.bin/':$PATH

if [ -d /mnt/c/Windows ]; then
  . $HOME/.wsl.sh
fi

# -------------------------------------------

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

# some more ls aliases
alias ll='ls --color -alF'
alias la='ls --color -A'
alias l='ls --color -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias k="kubectl"
alias g="/usr/bin/gh"

alias yarn="yarn --emoji true"

downloaded_vim=$HOME/nvim-linux64/bin/nvim
compiled_vim=/usr/local/bin/nvim
if [ -f $compiled_vim ]; then
  my_nvim_exec=$compiled_vim
else
  if [ -f $downloaded_vim ]; then
    my_nvim_exec=$downloaded_vim
  else
    if [ -f /usr/bin/nvim ]; then
      my_nvim_exec=/usr/bin/nvim
    else
      my_nvim_exec=/usr/bin/vim
    fi
  fi
fi
export EDITOR=$my_nvim_exec
alias vim="$my_nvim_exec"
alias nvim="$my_nvim_exec"
alias vhome="$my_nvim_exec ~"
alias v="$my_nvim_exec ."

alias ip="ip -c"
alias df="df -h"
alias free="free -m"

alias rm="rm -i"
alias cp="cp -i"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && \
  source "$HOME/.sdkman/bin/sdkman-init.sh"

