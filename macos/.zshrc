# Path to your oh-my-zsh installation.
export ZSH=/Users/yash/.oh-my-zsh

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
plugins=(autojump docker docker-compose git golang gradle gradle-completion kubectl lol node npm nvm osx zsh-autosuggestions zsh-syntax-highlighting)

# User configuration

export PATH=$PATH:"/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/yash/bin:/Users/yash/Library/Android/sdk/tools:/Users/yash/Library/Android/sdk/tools/bin:/Users/yash/Library/Android/sdk/platform-tools:/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin:/Users/yash/Library/Python/3.6/bin:/Users/yash/bin:/Users/yash/flutter/bin:/Users/yash/Library/Python/3.7/bin:/Users/yash/.cargo/bin"
# export MANPATH="/usr/local/man:$MANPATH"

eval "$(rbenv init -)"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

function close_other_tabs() {
  local the_app=$(_omz_osx_get_frontmost_app)

  if [[ "$the_app" == 'Terminal' ]]; then
    # Discarding stdout to quash "tab N of window id XXX" output
    osascript >/dev/null <<EOF
      tell application "System Events"
        tell process "Terminal" to keystroke "w" using {command down, option down}
      end tell
EOF
  fi
}

function to-code() {
  open -fn -a /Applications/Visual\ Studio\ Code.app
}

function adb-screencap() {
  adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > $1
}

function nukedis() {
  gpristine
  if [[ $1 == '--nvm' ]]; then
    nvm use
  fi

  npm i
}

function clean-containers() {
  docker rm $(docker ps -a -q)
}

function clean-images() {
  docker rmi $(docker images -q)
}

function chromecast-force-update() {
  if [ $# -eq 0 ]; then
    echo "This function needs an IP address to work"
    echo "Usage: chromecast-force-update <ip_address>"
    return 1
  fi
  curl -X POST -H "Content-Type: application/json" -d '{"params": "ota foreground"}' http://$1:8008/setup/reboot -v
}

function show-npm-scripts() {
  FILE=package.json
  if [ -f "$FILE" ]; then
    /bin/cat package.json | jq '.scripts'
  else
    echo "Current directory does not contain a package.json"
    return 1
  fi
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

function rename-files-from-kebob-to-pascal() {
  for entry in *.gcode; do
    mv $entry $(echo $entry | perl -p -e 's/(-)([a-z0-9])/\U\2/g' | perl -p -e 's/^(.)/\U\1/g')
  done
}

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias vimconfig="vim ~/.vimrc"
alias tmuxconfig="vim ~/.tmux.conf"

# set the GOPATH
export GOPATH="/Users/yash/go"
export PATH="$PATH:$GOPATH/bin"

# set the Java_HOME
export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home"
export PATH="$PATH:$JAVA_HOME/bin"

export NVM_DIR="/Users/yash/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# eval "$(thefuck --alias)"
# You can use whatever you want as an alias, like for Mondays:
# eval "$(thefuck --alias FUCK)"

alias setup-npm="npm install --global typescript ava eslint babel-cli prettier"
alias npm-dryrun-publish="npm pack && tar -xvzf *.tgz && rm -rf package *.tgz"

alias playground="~/playground"
alias godev="~/go"
alias gitdir="~/git-yash"
alias browse-things="open -a Finder ~/things"

alias gai="git add -i"
alias gms="git merge --squash"
alias gaom="git ls-files --modified | xargs git add"
alias gfsd="git file-size-diff"

alias fbd="firebase deploy:hosting"
alias fbo="firebase open"
alias crad="cordova run android --device"
alias crid="cordova run ios --device"

alias serve-pwd="python -m SimpleHTTPServer"

alias adblog="adb logcat jxcore-log:v cordova*:v *:s"
alias adblog-chrome="adb logcat jxcore-log:v cordova*:v chrom*:v *:s"

alias tmux="tmux -2"
alias tmuxa="tmux attach -t"
alias tmuxn="tmux new -s"
alias tmuxk="tmux kill-session -t"
alias tmuxl="tmux ls"

alias de="dep ensure"
alias dea="dep ensure -add"
alias deu="dep ensure -update"
alias ds="dep status"
alias depgraph="dep status -dot | dot -T png | open -f -a /Applications/Preview.app"
alias gdocl="go-doc-piped-to-less"

alias docker-exit-code="docker inspect --format='{{.State.ExitCode}}'"

alias c="clear"
alias l="exa -abhHlS"
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

alias now-in-unix="node -p 'Date.now()'"

# added by travis gem
[ -f /Users/yash/.travis/travis.sh ] && source /Users/yash/.travis/travis.sh

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
