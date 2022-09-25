## devenv

The dockerfile in this repo represents a best effort image that has most of the tooling that is configured in the dotfiles here. Specifically it targets the container dotfiles, builds out a full image with the requisite tools, all that remains to do is

- pick a language to set up, or pick multiple
- configure git with your credentials
- configure the AWS CLI

Note that this is meant to be a stateless container. It is recommended that each session be ended with saving your work either using a version control system or saving to a volume mounted within the container.

### Configuration

The container includes commands that start with `setup-` that enable quick setups for the following languages and runtimes

- Deno via `setup-deno`
- Golang via `setup-golang`
- Node.js via `setup-node`
- Python via `setup-python`
- Ruby via `setup-ruby`
- Rust via `setup-rust`

All of the language setup commands are configured to either pull down the latest version of the compiler. To configure the AWS CLI, you can either run `aws configure` or pass in `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` variables during runtime to embed credentials into the container.

The container will print a message out on first login with this information and the message can be recalled by running `show-devenv-help`.

#### Language specific notes

- You can optionally pass a version into the the `setup-go` command, like `setup-go v1.19.1`. It will try to fetch the latest version from the go website though.
- The node setup actually installs [`nvm`](https://github.com/nvm-sh/nvm) so the additional step there is to run `nvm install <desired_version_of_node>` to install an actual runtime.
- The python setup installs both python 3 and virtualenv, we don't bother with python 2.
- The ruby setup actually installs [rbenv with ruby-build as a plugin](https://github.com/rbenv/rbenv). The additional setup required is to install a ruby version.
- The rust setup installs `rustup` which is the rust toolchain manager.

### Cool. How do I run it?

You can just run it by pulling `docker run --rm -it --name <container_name> yashdalfthegray/devenv:latest`.

The image is also available on [public ECR](https://gallery.ecr.aws/yashdalfthegray/devenv) and can be pulled using `docker run --rm -it --name <container_name> public.ecr.aws/yashdalfthegray/devenv:latest`

Alternatively, you can pull down the repository linked below and run `docker build -t <image_name> .` which will build an image out of the files. You'll need acces to the internet to build the image. Then running a `docker run --rm -it --name <container_name> <image_name>:latest` will run the container.

[Repository](https://github.com/YashdalfTheGray/dotfiles)

There is another mode that this container can be run to support workflows where the need is to launch the container and then connect to it at a later point of time via a `docker exec` or similar command. This can be done by simply passing a `true` to the container entrypoint script as seen below,

```
docker run -d --rm --name <container_name> <image_name>:latest true`
```
