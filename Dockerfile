FROM debian:buster

# This Dockerfile contains the entire development environment
# Some of this is potentially best effort

ARG USERNAME=dev
ARG USERPASSWORD=dev
ARG GOVERSION=1.13
ARG NODEVERSION=13.12.0
ARG RUBYVERSION=2.7.1

# pull down some dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  exa \
  fzf \
  git \
  jq \
  tmux \
  vim \
  wget \
  zsh

# install golang manually
RUN cd /tmp \
  && wget -q https://dl.google.com/go/go${GOVERSION}.linux-amd64.tar.gz \
  && tar -C /usr/local -xzf go${GOVERSION}.linux-amd64.tar.gz

# set up home directory for users
RUN mkdir -p /home

# create a new user inside the docker container
RUN adduser --quiet --disabled-password --shell /bin/zsh --home /home/${USERNAME} --gecos "User" ${USERNAME} \
  && echo "${USERNAME}:${USERPASSWORD}" | chpasswd && usermod -aG sudo ${USERNAME}

# switch to the user so that everything is installed for it
USER ${USERNAME}

# make some directories
RUN mkdir -p /home/${USERNAME}/git-projects \
  && mkdir -p /home/${USERNAME}/tmp \
  && mkdir -p /home/${USERNAME}/go

# Setup our env - gopath, goroot, and path
ENV USER=${USERNAME} \
  USERNAME=${USERNAME} \
  GOROOT="/usr/local/go/bin" \
  PATH="/home/${USERNAME}/.rbenv/bin:/home/${USERNAME}/.rbenv/shims:${PATH}"

# install oh-my-zsh and a couple of added tools, because otherwise, what's the point
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install some other tools
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
RUN wget -qO- https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash

# copy the files that need to be in place
COPY linux/.zshrc linux/.tmux.conf linux/.vimrc /home/${USERNAME}/

# set our working directory as the git projects directory
WORKDIR /home/${USERNAME}/git-projects

# start in zsh instead of bash
CMD [ "zsh" ]
