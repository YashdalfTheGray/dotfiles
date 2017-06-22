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
plugins=(adb atom git gulp lol osx sublime)

# User configuration

export PATH=$PATH:"/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/yash/bin:/Users/yash/Library/Android/sdk/tools:/Users/yash/Library/Android/sdk/tools/bin:/Users/yash/Library/Android/sdk/platform-tools:/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin"
# export MANPATH="/usr/local/man:$MANPATH"

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

function close_current_tab() {
  local the_app=$(_omz_osx_get_frontmost_app)

  if [[ "$the_app" == 'Terminal' ]]; then
    # Discarding stdout to quash "tab N of window id XXX" output
    osascript >/dev/null <<EOF
      tell application "System Events"
        tell process "Terminal" to keystroke "w" using command down
      end tell
EOF
  fi
}

function to-atom() {
    open -fn -a /Applications/Atom.app
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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

# set the GOPATH
export GOPATH="/Users/yash/go-vendor"
export PATH="$PATH:$GOPATH/bin"

export NVM_DIR="/Users/yash/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

eval "$(thefuck --alias)"
# You can use whatever you want as an alias, like for Mondays:
eval "$(thefuck --alias FUCK)"

alias playground="~/playground"

alias gai="git add -i"

alias att="open . -a /Applications/Atom.app"

alias fbd="firebase deploy:hosting"
alias fbo="firebase open"
alias crad="cordova run android --device"
alias crid="cordova run ios --device"

alias django-admin="python3 /usr/local/bin/django-admin.py"

alias serve-pwd="python -m SimpleHTTPServer"

alias adblog="adb logcat jxcore-log:v cordova*:v *:s"
alias adblog-chrome="adb logcat jxcore-log:v cordova*:v chrom*:v *:s"

alias c="clear"
alias weather="curl http://wttr.in/"

alias sourcream="source ~/.zshrc"

# added by travis gem
[ -f /Users/yash/.travis/travis.sh ] && source /Users/yash/.travis/travis.sh

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
