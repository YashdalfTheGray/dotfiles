## devenv

The dockerfile in this repo represents a best effort image that has most of the tooling that is configured in the dotfiles here. Specifically it targets the container dotfiles, builds out a full image with the requisite tools, all that remains to do is

- pick a language to set up, or pick multiple
- configure git with your credentials
- configure the AWS CLI

The container includes commands that start with `setup-` that enable quick setups for the following languages and runtimes

- Deno via `setup-deno`
- Golang via `setup-golang`
- Node.js via `setup-node`
- Ruby via `setup-ruby`
- Rust via `setup-rust`

All of the language setup commands are configured to either pull down the latest version of the compiler or install a version manager, in the case of Node.js, Ruby, and Rust. You can optionally pass in a version in the format v1.19.1 to the `setup-go` command.

To configure the AWS CLI, you can either run `aws configure` or pass in `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` variables during runtime to embed credentials into the container.

The container will print a message out on first login with this information and the message can be recalled by running `show-devenv-help`.

### Cool. How do I run it?

You can just run it by pulling `docker run --rm -it --name <container_name> yashdalfthegray/devenv`.

Alternatively, you can pull down the repository linked below and run `docker build -t <image_name> .` which will build an image out of the files. You'll need acces to the internet to build the image. Then running a `docker run --rm -it --name <container_name> <image_name>:latest` will run the container.

[Repository](https://github.com/YashdalfTheGray/dotfiles)
