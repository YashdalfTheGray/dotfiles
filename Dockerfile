FROM debian:latest

# This Dockerfile contains the entire development environment
# Some of this is potentially best effort

ARG USERNAME=dev
ARG USERPASSWORD=dev
ARG GOVERSION=1.16.5

# pull down some dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  build-essential \
  curl \
  exa \
  fzf \
  git \
  jq \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  locales \
  sqlite3 \
  tree \
  tmux \
  unzip \
  vim \
  wget \
  zlib1g-dev \
  zsh

# Set up a message of the day to tell the user about this container
COPY motd /etc/

# install golang manually
RUN cd /tmp \
  && wget -q https://dl.google.com/go/go${GOVERSION}.linux-amd64.tar.gz \
  && tar -C /usr/local -xzf go${GOVERSION}.linux-amd64.tar.gz

# install the rust toolchain installer too
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install the AWS CLI v2
RUN cd /tmp \
  && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install

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

# setup our env - user, goroot, and path
ENV \
  USER=${USERNAME} \
  USERNAME=${USERNAME} \
  GOROOT="/usr/local/go/bin" \
  PATH="/home/${USERNAME}/.rbenv/bin:/home/${USERNAME}/.rbenv/shims:${PATH}:/home/${USERNAME}/.cargo/bin"

# run a quick rust update to get the latest stable version
RUN rustup update

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

# install the vim plugins
RUN vim +PlugInstall +qall > /dev/null

# set our working directory as the git projects directory
WORKDIR /home/${USERNAME}/git-projects

# start in zsh instead of bash
CMD [ "zsh" ]
