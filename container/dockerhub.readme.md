## devenv

The dockerfile in this repo represents a best effort image that has most of the tooling that is configured in the dotfiles here. Specifically it targets the linux dotfiles, builds out a full image with the requisite tools, all that remains to do is

- configure git with your credentials
- select and install a version of ruby and/or node if you're gonna use those
- configure the AWS CLI

Since the container already has `rbenv` and `nvm`, you should just be able to run `rbenv install <ruby_version>` and/or `nvm install <node_version>` to install the right things. Additionally, a (at the time of writing) recent version of Golang as well as the Rust toolchain are also installed into the container.

To configure the AWS CLI, you can either run `aws configure` or pass in `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` variables during runtime to embed credentials into the container.

### Cool. How do I run it?

You can just run it by pulling `docker run --rm -it --name <container_name> yashdalfthegray/devenv`.

You can pull down the repository linked below and just run `docker build -t <image_name> .` which will build an image out of the files. You'll need the internet to build the image. Then running a `docker run --rm -it --name <container_name> <image_name>:latest` will run the container.

The container will print out a message to tell you the all of the things that you can configure before getting started working on the container itself.

[Repository](https://github.com/YashdalfTheGray/dotfiles)
