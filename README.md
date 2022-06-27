# dotfiles

My terminal config files, grouped by os. With a little Docker surprise.

## Dockerfile?

The dockerfile in this repo represents a best effort image that has most of the tooling that is configured in the dotfiles here. Specifically it targets the linux dotfiles, builds out a full image with the requisite tools, all that remains to do is

- configure git with your credentials
- select and install a version of ruby and/or node if you're gonna use those
- configure the AWS CLI

Since the container already has `rbenv` and `nvm`, you should just be able to run `rbenv install <ruby_version>` and/or `nvm install <node_version>` to install the right things. Additionally, a (at the time of writing) recent version of Golang as well as the Rust toolchain are also installed into the container.

To configure the AWS CLI, you can either run `aws configure` or pass in `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` variables during runtime to embed credentials into the container.

### Cool. How do I run it?

You can pull down this repository and just run `docker build -t <image_name> .` which will build an image out of the files. You'll need the internet to build the image. Then running a `docker run --rm -it --name <container_name> <image_name>:latest` will run the container.

The container will print out a message to tell you the all of the things that you can configure before getting started working on the container itself.

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

Pulls the theme from the terminal color scheme, has mouse support, NERDTree and FZF support, as well as git markers for files and the gutter. Additionally, for systems that have Python3 interface support, there is also deoplete automcompletion. Separately, a language server client is also installed and enabled for Rust and Ruby.

### `tmux`

The `.tmux.conf` file sets some shortcuts and a theme for `tmux`. This has been tested on tmux version 2.9 and newer. To make it work for tmux <2.8, you'll need to change the `-style` commands into their own separate commands. That's a change that was brought around by version 2.9.

Uses [`tpm`](https://github.com/tmux-plugins/tpm) for installing plugins.

## What are these other folders about?

Most of the other folders in this repo are modifications on the macOS versions of the files.

## How do I fix the vim deoplete issue that I keep running into?

While using vim, if you want autocomplete, one of the packages you can use is [`deoplete`](https://github.com/Shougo/deoplete.nvim). Deoplete has a hard dependency on a python package called `pynvim` and basically requires Python3 support. Though you can get around it if you have `pynvim` installed. But since managing versions of python can be difficult, you can figure out which version of python your vim is looking at by running the following code

```
:pythonx import sys; print(sys.path)
```

The step after this becomes a bit of a choose your own adventure depending on the major version of Python vim has found. Refer below.

### Python3

Figure out how to get access to the python executable that vim is looking at. On modern \*nix style OSes, it likely exists at a path similar to `/usr/local/opt/python@3.y/bin/python3` though it may be different. This path is specific to macOS and Homebrew.

You can validate that you have the right path by running

```
<path_to_python> --version
```

If you don't have `pip`, you'll need to pull that down next. Starting with Python 3.4, `pip` is included in the bundle. Otherwise, head [here](https://pip.pypa.io/en/stable/installation/) to install.

Once you have the path and `pip`, run

```
<path_to_python> -m pip install --user --upgrade pynvim
```

This will install `pynvim` and allow vim, thus deoplete, to find `pynvim`.

### Python2

Figure out how to get access to the python executable that vim is looking at. This is likely at a system path like `/usr/bin` or `/usr/local/bin` but your mileage may vary on this.

If you don't have `pip`, you'll need to pull that down next. Starting with Python 2.7, `pip` is included in the bundle. Otherwise, head [here](https://pip.pypa.io/en/stable/installation/) to install. Though I have also found that `pip` wasn't boostrapped properly even on installations reporting version 2.7 or higher.

Once you have the path and `pip`, run

```
<path_to_python> -m pip install --user --upgrade pynvim
```

This will install `pynvim` and allow vim, thus deoplete, to find `pynvim`.

## Resources

- [tmux cheat sheet](https://gist.github.com/MohamedAlaa/2961058)
- [tmux color sheet](https://i.stack.imgur.com/e63et.png)
