# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ys"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"
# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  brew
  copypath
  copyfile
  copybuffer
  deno
  docker
  docker-compose
  fzf
  git
  golang
  kubectl
  macos
  node
  rust
  zsh-autosuggestions
  fast-syntax-highlighting
)

typeset -U path PATH fpath FPATH

source $ZSH/oh-my-zsh.sh

add_to_path() {
    local prioritize=false
    local directory
    local entry
    local -a remaining_entries=()

    if [[ "${1-}" == "--prioritize" ]]; then
        prioritize=true
        shift
    fi

    if (( $# != 1 )) || [[ -z "$1" || "$1" == *:* ]]; then
        print -u2 "Usage: add_to_path [--prioritize] DIRECTORY"
        return 1
    fi

    directory="$1"

    for entry in "${path[@]}"; do
        if [[ "$entry" == "$directory" ]]; then
            if [[ "$prioritize" == false ]]; then
                return 0
            fi
        else
            remaining_entries+=("$entry")
        fi
    done

    if [[ "$prioritize" == true ]]; then
        path=("$directory" "${remaining_entries[@]}")
    else
        path+=("$directory")
    fi

    export PATH
}

# Android shit
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"

# set the GOPATH
export GOPATH="$HOME/go"

# PATH fuckery
add_to_path "$HOME/bin"
add_to_path "$HOME/.swiftly/bin"
add_to_path "$HOME/flutter/bin"
add_to_path "$HOME/.cargo/bin"
add_to_path "/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin"
add_to_path "$ANDROID_SDK_ROOT/emulator"
add_to_path "$ANDROID_SDK_ROOT/platform-tools"
add_to_path "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"
add_to_path "$ANDROID_SDK_ROOT/tools"
add_to_path "$ANDROID_SDK_ROOT/tools/bin"
add_to_path "$GOPATH/bin"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# editor configuration
export EDITOR='nvim'
export VISUAL='nvim'

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Functions
function to-code() {
  open -fn -a /Applications/Visual\ Studio\ Code.app
}

function adb-screencap() {
  adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > $1
}

function clean-containers() {
  docker rm $(docker ps -a -q)
}

function clean-images() {
  docker rmi $(docker images -q)
}

function curl-from-github-and-save() {
  if [ $# -eq 0 ]; then
    echo "Get raw files from GitHub and store them with the same name as the URL."
    echo "Usage: curl-from-github-and-save user/repository/branch/filename"
    return 1
  fi

  curl -OJ https://raw.githubusercontent.com/$1
}

function curl-pipe-to-jq() {
  output=$(curl -vs "$@" 2>&1)
  curl_command_exit_code=$?

  if [ $curl_command_exit_code -ne 0 ]; then
    printf '%s\n' "$output"
  else
    response_code=$(printf '%s' "$output" | sed -En 's/< HTTP\/(.*) ([1-5][0-9]{2}) (.*)/\2/ p')
    response_text=$(printf '%s' "$output" | sed -En 's/< HTTP\/(.*) ([1-5][0-9]{2}) (.*)/\3/ p')

    if [[ $response_code == "200" ]]; then
      json_body=$(printf '%s' "$output" | sed -En 's/(\{.*\})/\1/ p')

      printf '%s' $json_body | jq
    else
      printf '%s %s\n' "$response_code" "$response_text"
    fi
  fi
}

function go-doc-piped-to-less() {
  output=$(go doc "$@")
  go_doc_exit_code=$?

  if [ $go_doc_exit_code -ne 0 ]; then
    printf '%s' $output
  else
    printf '%s' $output | less
  fi
}

function uuidgen() {
  /usr/bin/uuidgen | awk '{print tolower($0)}'
}

function generate-uuids() {
  if [ $# -eq 0 ]; then
    uuidgen
    return 0
  fi

  if (( $1 <= 1 )); then
    uuidgen
    return 0
  fi

  for i in {1..$1}; do /usr/bin/uuidgen; done | awk '{print tolower($0)}'
}

# Aliases
alias zshconfig="nvim ~/.zshrc"
alias omzconfig="nvim $ZSH"
alias vimconfig="nvim ~/.vimrc"
alias nvimconfig="nvim ~/.config/nvim/init.vim"
alias tmuxconfig="nvim ~/.tmux.conf"
alias setup-npm="npm install --global typescript ava eslint prettier"
alias npm-dryrun-publish="npm pack && tar -xvzf *.tgz && rm -rf package *.tgz"

alias playground="~/playground"
alias godev="~/go"
alias gitdir="~/git-yash"
alias browse-things="open -a Finder ~/things"
alias reload="exec zsh"
alias serve-pwd="python3 -m http.server"

alias gai="git add -i"
alias gms="git merge --squash"
alias gaom="git ls-files --modified | xargs git add"
alias gfsd="git file-size-diff"

alias tmux="tmux -2"
alias tmuxa="tmux attach -t"
alias tmuxn="tmux new -s"
alias tmuxk="tmux kill-session -t"
alias tmuxl="tmux ls"
alias tmuxc="tmux -CC new -A -s"
alias tmuxca="tmux -CC attach -t"

alias gdocl="go-doc-piped-to-less"

alias c="clear"
alias l="eza -abhHlS"
alias llg="eza -abhHlS --git --icons"
alias tree="tree -CF"
alias t="tree"
alias weather="curl http://wttr.in/"

alias sourcream="source ~/.zshrc"
alias sloc="git ls-files | xargs wc -l"
alias gcurl="curl-from-github-and-save"
alias jqcurl="curl-pipe-to-jq"
alias get-aws-account="aws sts get-caller-identity | jq -r '.Account'"
alias copy-aws-account="aws sts get-caller-identity | jq -jr '.Account' | pbcopy"

alias getuuid="generate-uuids"
alias getuuids="generate-uuids"

# tailscale shit because macOS appstore sucks donkeyballs
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

alias now-in-unix="node -p 'Date.now()'"
alias unixnow="now-in-unix"

# Other exports
export DISABLE_TELEMETRY=1
export DO_NOT_TRACK=1

# rbenv trash
eval "$(rbenv init - zsh)"

# mise trash (curl install -> ~/.local/bin/mise)
eval "$(~/.local/bin/mise activate zsh)"

# fzf
source <(fzf --zsh)

# zoxide
eval "$(zoxide init zsh)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
