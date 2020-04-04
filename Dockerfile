FROM debian:buster

# This Dockerfile contains the entire development
# environment, set up to the best approximation

# pull down some dependencies
RUN apt-get update && apt-get install -y tmux git vim zsh wget

# change the shell to zsh
RUN chsh -s /usr/bin/zsh root

# install oh-my-zsh, because otherwise, what's the point
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# copy the files that need to be in place
COPY macos/.zshrc $HOME/.zshrc
COPY macos/.tmux.conf $HOME/.tmux.conf
COPY macos/.vimrc $HOME/.vimrc

# make ourselves a git directory
RUN mkdir -p $HOME/git-projects

# set our working directory as the git projects directory
WORKDIR $HOME/git-projects

CMD [ "zsh" ]
