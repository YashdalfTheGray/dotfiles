FROM debian:buster

# This Dockerfile is only here for me to be able to test
# my deploy scripts. It has nothing to do with the actual
# dotfiles in this repository and their content.

ARG generate_bin=false

# Make the folder for all the code
RUN mkdir -p /root/git-projects/dotfiles

# Copy the code
COPY . /root/git-projects/dotfiles
