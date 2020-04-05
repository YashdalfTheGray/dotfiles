FROM debian:buster

# This Dockerfile contains the entire development
# environment, set up to the best approximation

# pull down some dependencies
RUN apt-get update && apt-get install -y \
  fzf \
  git \
  jq \
  tmux \
  vim \
  wget \
  zsh

# install oh-my-zsh, because otherwise, what's the point
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# copy the files that need to be in place
COPY linux/.zshrc $HOME/.zshrc
COPY linux/.tmux.conf $HOME/.tmux.conf
COPY linux/.vimrc $HOME/.vimrc

# make ourselves a git directory
RUN mkdir -p $HOME/git-projects

# set our working directory as the git projects directory
WORKDIR $HOME/git-projects

CMD [ "zsh" ]
