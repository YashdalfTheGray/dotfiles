# dotfiles

My terminal config files, grouped by os. With a little Docker surprise.

## Dockerfile?

The dockerfile in this repo represents a best effort image that has most of the tooling that is configured in the dotfiles here. Specifically it targets the linux dotfiles, builds out a full image with the requisite tools, all that remains to do is

- configure git with your credentials
- select and install a version of ruby and/or node if you're gonna use those
- configure the AWS CLI

Since the container already has `rbenv` and `nvm`, you should just be able to run `rbenv install <ruby_version>` and/or `nvm install <node_version>` to install the right things.

To configure the AWS CLI, you can either run `aws configure` or pass in `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` variables during runtime to embed credentials into the container.

## macOS

### `oh-my-zsh`

Expects [`rbenv`](https://github.com/rbenv/rbenv), [`nvm`](https://github.com/nvm-sh/nvm), [`fzf`](https://github.com/junegunn/fzf), and [iTerm2](https://iterm2.com/) to be used in conjunction with this file. You can also just comment those pieces out.

Installed plugins

- autojump
- docker
- docker-compose
- git
- golang
- kubectl
- lol
- node
- npm
- npx
- nvm
- osx
- zsh-autosuggestions
- zsh-syntax-highlighting

Uses the [ys](https://github.com/robbyrussell/oh-my-zsh/wiki/themes#ys) theme.

### `vim`

Uses [vim-plug](https://github.com/junegunn/vim-plug) as the package manager.

Pulls the theme from the terminal color scheme, has mouse support, NERDTree and FZF support, as well as git markers for files and the gutter.

### `tmux`

The `.tmux.conf` file sets some shortcuts and a theme for `tmux`. This has been tested on tmux version 2.9 and newer. To make it work for tmux <2.8, you'll need to change the `-style` commands into their own separate commands. That's a change that was brought around by version 2.9.

Uses [`tpm`](https://github.com/tmux-plugins/tpm) for installing plugins.

## Resources

- [tmux cheat sheet](https://gist.github.com/MohamedAlaa/2961058)
- [tmux color sheet](https://i.stack.imgur.com/e63et.png)
