# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ys"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  autojump
  deno
  git
  golang
  node
  nvm
  rust
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# User configuration

export PATH=$PATH:"$HOME/bin"
# set the GOPATH
export GOPATH="$HOME/go"
export GOROOT="/usr/local/go"

# Set the actual PATH envvar
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin:$HOME/.rbenv/bin:$HOME/.rbenv/shims"

# set terminal color support
export TERM=xterm-256color

source $ZSH/oh-my-zsh.sh

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

function setup-go() {
  set -x
  local GOVERSION=""

  if [ $# -eq 0 ]; then
    GOVERSION=$(curl https://go.dev/VERSION\?m\=text)
  else
    GOVERSION="go${1/v/}"
  fi

  pushd /tmp
  wget -q https://dl.google.com/go/${GOVERSION}.linux-amd64.tar.gz
  tar -C /usr/local -xzf ${GOVERSION}.linux-amd64.tar.gz
  rm -rf ${GOVERSION}.linux-amd64.tar.gz
  popd
  set +x
}

function setup-ruby() {
  set -x
  git clone --depth 1 https://github.com/rbenv/rbenv.git ~/.rbenv
  git clone --depth 1 https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | bash
  set +x
}

alias zshconfig="vim $HOME/.zshrc"
alias ohmyzsh="vim $HOME/.oh-my-zsh"
alias vimconfig="vim $HOME/.vimrc"
alias tmuxconfig="vim $HOME/.tmux.conf"

alias setup-npm="npm install --global typescript ava eslint babel-cli firebase-tools particle-cli elm elm-github-install vue-cli ndb"
alias npm-dryrun-publish="npm pack && tar -xvzf *.tgz && rm -rf package *.tgz"

alias gitdir="$HOME/git-projects"

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

# install fzf keybindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

cat /etc/motd
