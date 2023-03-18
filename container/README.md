# Devenv container

## Building

This repository uses a multiarch build system to publish both `arm64` and `amd64` images to Dockerhub. This is done using the `docker buildx` command.

You can create a new buildx builder using `docker buildx create --name <some_memorable_name>` and then start it up immediately it by inspecting it through `docker use <that_same_name> && docker buildx inspect --bootstrap`.

Once you have that going, run a docker build by running `docker buildx build --platform amd64,arm64 -t <your_dockerhub_repo>:<tag> . --push`. You have to push the images right away since if you don't use the `--push` flag, the images are built but they sit in the docker build cache.
