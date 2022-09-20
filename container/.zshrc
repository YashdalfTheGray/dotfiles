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
  deno
  git
  golang
  node
  nvm
  rbenv
  ruby
  rust
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# set default editor for all sorts of things
export VISUAL=vim
export EDITOR="$VISUAL"

# User configuration
export PATH=$PATH:"$HOME/bin"

# set the GOPATH
export GOPATH="$HOME/go"
export GOROOT="/usr/local/go"

# NVM setup
export NVM_DIR="$HOME/.nvm"

# Deno setup
export DENO_INSTALL="/root/.deno"

# Set the actual PATH envvar
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin:$HOME/.rbenv/bin:$HOME/.rbenv/shims:$HOME/.cargo/bin:$DENO_INSTALL/bin"

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

function install-awscli() {
  set -x
  pushd /tmp
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install
  rm awscliv2.zip
  popd
  set +x
}

function setup-deno() {
  set -x
  curl -fsSL https://deno.land/install.sh | sh
  set +x
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


function setup-node() {
  set -x
  local NVMVERSION="${1:-v0.39.1}"
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/${NVMVERSION}/install.sh | bash
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.zshrc
  set +x
}

function setup-ruby() {
  set -x
  git clone --depth 1 https://github.com/rbenv/rbenv.git ~/.rbenv
  git clone --depth 1 https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | bash
  set +x
}

function setup-rust() {
  set -x
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  set +x
}

# install fzf keybindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# only echo the motd once
[ ! -f /etc/disable-motd-cat ] && { cat /etc/motd.md && touch /etc/disable-motd-cat }

alias zshconfig="vim $HOME/.zshrc"
alias ohmyzsh="vim $HOME/.oh-my-zsh"
alias vimconfig="vim $HOME/.vimrc"
alias tmuxconfig="vim $HOME/.tmux.conf"
alias show-devenv-help="vim -M /etc/motd.md"

alias setup-npm="npm install --global typescript ava eslint"
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
