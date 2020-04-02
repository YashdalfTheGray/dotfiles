FROM debian:buster

# This Dockerfile contains the entire development
# environment, set up to the best approximation

# pull down some dependencies
RUN apt-get update && apt-get install -y tmux git vim zsh

# change the shell to zsh
RUN chsh -s /usr/bin/zsh root

# make ourselves a git directory
RUN mkdir -p $HOME/git-projects

# set our working directory as the git projects directory
WORKDIR $HOME/git-projects
