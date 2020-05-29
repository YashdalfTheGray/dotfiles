# Path to your oh-my-zsh installation.
export ZSH=/home/$USER/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ys"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git golang node npm npx nvm zsh-autosuggestions zsh-syntax-highlighting)

# User configuration

export PATH=$PATH:"/home/$USER/bin"
# set the GOPATH
export GOPATH="$HOME/go"
export GOROOT="/usr/local/go"
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"

export LANG=en_US.UTF-8
export TERM=xterm-256color

source $ZSH/oh-my-zsh.sh

function running_in_docker() {
  awk -F/ '$2 == "docker"' /proc/self/cgroup | read
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

alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias vimconfig="vim ~/.vimrc"
alias tmuxconfig="vim ~/.tmux.conf"

alias setup-npm="npm install --global typescript ava eslint babel-cli firebase-tools particle-cli elm elm-github-install vue-cli ndb"
alias npm-dryrun-publish="npm pack && tar -xvzf *.tgz && rm -rf package *.tgz"

alias gitdir="~/git-projects"

alias gai="git add -i"
alias gms="git merge --squash"
alias gaom="git ls-files --modified | xargs git add"
alias gfsd="git file-size-diff"

alias fbd="firebase deploy:hosting"
alias fbo="firebase open"
alias crad="cordova run android --device"
alias crid="cordova run ios --device"

alias serve-pwd="python -m SimpleHTTPServer"

alias tmux="tmux -2"
alias tmuxa="tmux attach -t"
alias tmuxn="tmux new -s"
alias tmuxk="tmux kill-session -t"
alias tmuxl="tmux ls"

alias gdocl="go-doc-piped-to-less"

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

eval "$(rbenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if running_in_docker ; then
  cat /etc/motd
fi
