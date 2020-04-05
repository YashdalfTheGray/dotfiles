FROM debian:buster

# This Dockerfile contains the entire development
# environment, set up to the best approximation

ARG USERNAME=dev
ARG USERPASSWORD=dev

# pull down some dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  fzf \
  git \
  jq \
  tmux \
  vim \
  wget \
  zsh

# install oh-my-zsh and a couple of added tools, because otherwise, what's the point
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# install some other tools
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
RUN wget -q https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer -O- | bash

# set up home directory for users
RUN mkdir -p /home

# copy the files that need to be in place
COPY linux/.zshrc $HOME/.zshrc
COPY linux/.tmux.conf $HOME/.tmux.conf
COPY linux/.vimrc $HOME/.vimrc

# make ourselves a git directory
RUN mkdir -p $HOME/git-projects

# set our working directory as the git projects directory
WORKDIR $HOME/git-projects

CMD [ "zsh" ]
