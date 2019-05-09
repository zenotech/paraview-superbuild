#!/bin/bash

# Simple build, choosing defaults for all options:

docker build --rm -t pv-v5.6.0-egl .

# Build version 5.6.0 w/ EGL:

# docker build --rm \
#   --build-arg BASE_IMAGE="nvidia/opengl:1.0-glvnd-devel-ubuntu18.04" \
#   --build-arg RENDERING="egl" \
#   --build-arg SUPERBUILD_REPO="https://gitlab.kitware.com/scott.wittenburg/paraview-superbuild.git" \
#   --build-arg SUPERBUILD_TAG="add-dockerfile-and-build-script" \
#   --build-arg PARAVIEW_TAG=v5.6.0 \
#   -t pv-v5.6.0-egl \
#   .

# Build version 5.6.0 w/ OSMesa:

# docker build --rm \
#   --build-arg BASE_IMAGE="ubuntu:18.04" \
#   --build-arg RENDERING="osmesa" \
#   --build-arg SUPERBUILD_REPO="https://gitlab.kitware.com/scott.wittenburg/paraview-superbuild.git" \
#   --build-arg SUPERBUILD_TAG="add-dockerfile-and-build-script" \
#   --build-arg PARAVIEW_TAG=v5.6.0 \
#   -t pv-v5.6.0-osmesa \
#   .
