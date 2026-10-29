# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="ys"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change the frequency the auto-updater is run (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line to set how old an update must be before it's applied, manually or via the auto-updater (in days).
# zstyle ':omz:update' cooldown 10

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  autojump
  docker
  docker-compose
  fast-syntax-highlighting
  git
  golang
  kubectl
  lol
  macos
  node
  nvm
  rust
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

typeset -U path PATH

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
        print -u2 "Usage: path_add [--prioritize] DIRECTORY"
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

# PATH fuckery
export PATH=$PATH:"/users/yash/bin"
add_to_path "/users/yash/bin"
add_to_path "/users/yash/.swiftly/bin"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.

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

alias zshconfig="nvim ~/.zshrc"
alias omzconfig="nvim $ZSH"
alias vimconfig="nvim ~/.vimrc"
alias nvimconfig="nvim ~/.config/nvim/init.vim"
alias tmuxconfig="nvim ~/.tmux.conf"
alias playground="~/playground"
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

alias c="clear"
alias l="eza -abhHlS"
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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(rbenv init - zsh)"
