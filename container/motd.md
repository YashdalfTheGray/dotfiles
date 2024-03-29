# Docker Devenv

Welcome to the devenv container. This combines common developer tooling like tmux+vim+zsh into a single container image and it includes commands to set up different languages as the user desires. This container is intended to be stateless, it is suggested that you either upload all your work to version control, or mount a volume to save it on the host or in the cloud.

The following commands to set up language support are available

- `setup-deno`: sets up Deno (https://deno.land/)
- `setup-go`: sets up Go (https://go.dev/)
- `setup-node`: sets up nvm (https://github.com/nvm-sh/nvm)
- `setup-python` - sets up python (https://www.python.org/)
- `setup-ruby`: sets up rbenv and ruby-build (https://github.com/rbenv/rbenv)
- `setup-rust`: sets up rustup (https://rustup.rs/)

Additionally, the GNU C/C++ compiler and `make` are already installed. All of the language setup commands are configured to either pull down the latest version of the compiler or install a version manager, in the case of Node.js, Ruby, and Rust. You can optionally pass in a version in the format v1.19.1 to the `setup-go` command.

There is also a command called `install-awscli` that will install AWS CLI v2.

Once you've picked a language, run the following commands to configure git and the AWS CLI.

```
aws configure
git config --global user.name "<your_username>"
git config --global user.email <your_email>
```

Lastly, vim is configured to install plugins on first start but does not use an autocomplete plugin because the most common ones need a language runtime to be installed. Follow the guides below to get started with autocomplete

- https://github.com/neoclide/coc.nvim
- https://github.com/Shougo/deoplete.nvim
- https://github.com/ycm-core/YouCompleteMe

You can run `show-devenv-help` to read this message again.
