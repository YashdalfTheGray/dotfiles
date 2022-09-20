FROM debian:latest

# pull down some dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  build-essential \
  curl \
  exa \
  git \
  jq \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  locales \
  procps \
  sqlite3 \
  tree \
  tmux \
  unzip \
  vim \
  wget \
  zlib1g-dev \
  zsh \
  && rm -rf /var/lib/apt/lists/*

# install oh-my-zsh and a couple of added tools, because otherwise, what's the point
ENV ZSH="/root/.oh-my-zsh"
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# copy the files that need to be in place
COPY container/.zshrc container/.tmux.conf container/.vimrc /root/

# install fzf once the right files are in place
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

# install the vim plugins
RUN vim +PlugInstall +qall > /dev/null

# Set up a message of the day to tell the user about this container
COPY container/motd.md /etc/

# Copy our start script
COPY container/start /etc/

# start a script that sleeps forever
ENTRYPOINT [ "/etc/start" ]
