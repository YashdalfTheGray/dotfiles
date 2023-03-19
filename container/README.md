# Devenv container

## Building

This repository uses a multiarch build system to publish both `arm64` and `amd64` images to Dockerhub. This is done using the `docker buildx` command.

You can create a new buildx builder using `docker buildx create --name <some_memorable_name>` and then start it up immediately it by inspecting it through `docker use <that_same_name> && docker buildx inspect --bootstrap`.

Once you have that going, run a docker build by running `docker buildx build --platform linux/amd64,linux/arm64 -t <your_dockerhub_repo>:<tag> . --push`. You can push the images right away since if you don't use the `--push` flag, the images are built but they sit in the docker build cache.

Alternatively, you can use the `--load` option to pull the images into the Docker image list but it only works when you specify a single platform, like `docker buildx build --platform linux/amd64 -t <your_dockerhub_repo>:<tag> . --load`.

## Pushing to ECR public

(I assume the same instructions would apply to a private ECR repo but I keep my images in public repos so that's the only case I've tested)

Swapping the tag in the command above for the ECR public tag doesn't quite work Docker buildx ends up pushing multiple images that are part of the manifest and then tagging the manifest. Which means that if you push the same image with a different tag again, you're going to end up with a new manifest. So we have to do a bit of manual work to make sure everything pushes right.

First we're going to build the different images one by one and load them into Docker using `docker buildx build --platform <platform> -t <your_ecr_repo>:<tag> . --load`. Once all the images for the different platforms are in place, we're going to create a Docker manifest for all the images, and then push that up.

To push the images up, use the standard `docker push` commands. To create a manifest, run `docker manifest create <manifest_name> <image_variant_1> <image_variant_2> ...`. Here the variants correspond to the image tags of the images we built with `docker buildx` and loaded into Docker.

To push the manifest up, use `docker manifest push <manifest_name>`.

## Running

See [running instructions in the main readme](../README.md#cool-how-do-i-run-it)

## References

- https://www.docker.com/blog/multi-arch-images/
- https://docs.aws.amazon.com/AmazonECR/latest/public/docker-push-multi-architecture-image.html
