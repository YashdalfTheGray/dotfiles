# dotfiles

My terminal config files, mostly grouped by os

## `oh-my-zsh`

Expects `rbenv`, `nvm`, and iTerm2 to be used in conjunction with this file. You can also just comment those pieces out. 

Installed plugins
* autojump
* docker
* docker-compose
* git
* golang
* kubectl
* lol
* node
* npm
* npx
* nvm
* osx
* zsh-autosuggestions
* zsh-syntax-highlighting

Uses the [ys](https://github.com/robbyrussell/oh-my-zsh/wiki/themes#ys) theme. 

## `vim`

Uses [vim-plug](https://github.com/junegunn/vim-plug) as the package manager. 

Pulls the theme from the terminal color scheme, has mouse support, NERDTree and FZF support, as well as git markers for files and the gutter. 

## `tmux`

The `.tmux.conf` file sets some shortcuts and a theme for `tmux`. This has been tested on tmux version 2.9 and newer. To make it work for tmux <2.8, you'll need to change the `-style` commands into their own separate commands. That's a change that was brought around by version 2.9. 

### Resources

* [tmux cheat sheet](https://gist.github.com/MohamedAlaa/2961058)
* [tmux color sheet](https://i.stack.imgur.com/e63et.png)
