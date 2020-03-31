FROM debian:buster

# This Dockerfile is only here for me to be able to test
# my deploy scripts. It has nothing to do with the actual
# dotfiles in this repository and their content.

# put down some bin files
RUN mkdir /root/bin
RUN touch /root/bin/test
RUN echo "echo \"this is a test\"" > /root/bin/test
RUN chmod +x /root/bin/test

# Make the folder for all the code
RUN mkdir -p /root/git-projects/dotfiles

# Copy the code
COPY . /root/git-projects/dotfiles
