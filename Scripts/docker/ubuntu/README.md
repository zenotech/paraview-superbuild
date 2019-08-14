# Introduction

The goal of this document is to describe the `Dockerfile` in this directory and how to use it to build, deploy, and run a variety of ParaView Docker images.

The basic idea of the `Dockerfile` is that it will first install some packages needed for running the ParaView Superbuild, then clone the superbuild and use the `CMake` initial cache located in `cmake/sites/Docker-Ubuntu-18_04.cmake` to provide the build options.

## Building images

This section describes building the ParaView `Docker` images using the `Dockerfile` in this directory.

### Description of build arguments

The `Dockerfile` accepts several build arguments (provided in the form `--build-arg OPTION=VALUE`) allowing the user to specify the following build options:

#### `BASE_IMAGE`

This could be an `nvidia` Docker image, or just a basic `ubuntu`.  The `nvidia` images are useful for creating `EGL` builds of ParaView, while other `ubuntu` images are good for OSMesa builds.

#### `RENDERING`

The options here are either `egl` or `osmesa`, make sure to pick a compatible base image for the option you choose.

#### `SUPERBUILD_REPO`

Defaults to main gitlab repo, but could point to a fork for testing branches.  The reason we need to clone to superbuild (instead of simply checking out the branch we want locally and building from that) is that `Docker` does not provide any kind of directory binding/mounting during the build process, likely for reasons related to build reproducibility.

#### `SUPERBUILD_TAG`

This could be any branch name, tag, or commit which exists on the `SUPERBUILD_REPO`, but defaults to latest release tag.

#### `PARAVIEW_TAG`

The option for this are the same as for `SUPERBUILD_TAG`, above.

#### `DEV_BUILD`

In order to allow you to preserve both the superbuild build tree as well as the version of `CMake` used during the build, this option accepts a value of `"true"`.  Any other value (including the default of `"false"`) results in the build tree and `CMake` installation getting cleaned out to reduce the final size of the built image.  This option can be helpful if you want to use the resulting `Docker` image to develop plugins against a particular version of ParaView.

#### `PYTHON_VERSION`

While the ParaView Superbuild supports building ParaView with either Python 2 or 3, this option is available to choose the version of system python to install in the container and use in the ParaView build.  The available options are simply `2` or `3`, with `2` being the default.  Due to how ubuntu handles python 2 and 3 packages, we have chosen to embed environment variables in the resulting image that indicate the name of the `pip` program.  These environment variables are defined as follows:

```
ENV SYSTEM_PYTHON_2_PIP pip
ENV SYSTEM_PYTHON_3_PIP pip3
ENV SYSTEM_PYTHON_PIP "SYSTEM_PYTHON_${PYTHON_VERSION}_PIP"
```

where `${PYTHON_VERSION}` is interpreted from the user-supplied python version.  In this way, a user of the resulting container can determine the appropriate program to use for installing packages by interpolating the `SYSTEM_PYTHON_PIP` environment variable as follows:

```bash
PIP_CMD="${!SYSTEM_PYTHON_PIP}"
```

### Build command-line examples

The simplest build just accepts all the defaults:

```
docker build --rm -t pv-vVERSION-egl
```

Here is an example of specifying non-default arguments for some of the build options.  This command builds an image using OSMesa for rendering, chooses the `master` branch of ParaView, and picks a branch of the superbuild from a developer fork:

```
docker build --rm \
  --build-arg BASE_IMAGE="ubuntu:18.04" \
  --build-arg RENDERING="osmesa" \
  --build-arg SUPERBUILD_REPO="https://gitlab.kitware.com/<some.user>/paraview-superbuild.git" \
  --build-arg SUPERBUILD_TAG="custom-branch-in-development" \
  --build-arg PARAVIEW_TAG=master \
  -t pv-master-osmesa-custom \
  .
```

## Deploying images

Deploying images you have built is a matter of tagging them and pushing them to Dockerhub (or some other image registry).  In order to tag images, you probably need to be logged in with your `Docker` ID on your local machine.  This can be accomplished by typing:

```
docker login
```

Then provide your `Docker` ID and password at the prompts.

To tag your image, the command looks like:

```
docker tag <local-image-tag> <desired-tag-name-for-registry>
```

For example to tag a local image tagged `pv-v5.6.1-egl`, as `kitware/paraviewweb:pv-v5.6.1-egl`, the command is as follows:

```
docker tag pv-v5.6.1-egl kitware/paraviewweb:pv-v5.6.1-egl
```

Once the image is tagged, you can push it to the registry using a command like the following (to push to Dockerhub):

```
docker push kitware/paraviewweb:pv-v5.6.1-egl
```

## Running images

To run images you have built as containers, use the `docker run` command.  To run a shell on the OSMesa container, you only need the image tag.  For example:

```
docker run --rm -ti pv-v5.6.1-osmesa
```

In order to run images based on the `nvidia-docker2` runtime (e.g. any `EGL` images you have built), you need to provide an extra argument to `docker run`, for example:

```
docker run --rm --runtime=nvidia -ti pv-v5.6.1-egl
```

Of course for that to work, you not only need the `nvidia-docker2` container runtime packages installed on your system, you also need an NVidia graphics card with the latest drivers installed.
