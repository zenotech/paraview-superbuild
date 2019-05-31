#
# To build this image and run it with a shell, first change into the directory
# where this Dockerfile lives, then:
#
# sudo docker build -t pv-v5.6.0-egl .
#
# Or, to choose a different version:
#
# sudo docker build --build-arg PARAVIEW_TAG=master --build-arg SUPERBUILD_TAG=master -t pv-master-egl .
#
# Run the image with bash to look around:
#
# sudo docker run --runtime=nvidia -ti pv-v5.6.0-egl bash
#

#
# Build options
#
#   BASE_IMAGE
#
#     nvidia/opengl:1.0-glvnd-devel-ubuntu18.04
#     ubuntu:18.04
#
#   RENDERING
#
#     egl
#     osmesa
#
#   PARAVIEW_TAG
#
#     "master", "v5.6.0", <branch-name>, etc...
#
#   SUPERBUILD_REPO
#
#     allows cloning from a fork
#
#   SUPERBUILD_TAG
#
#     "master", "v5.6.0", <branch-name>, etc...
#

ARG BASE_IMAGE=nvidia/opengl:1.0-glvnd-devel-ubuntu18.04
FROM ${BASE_IMAGE}

ARG RENDERING=egl
ARG PARAVIEW_TAG=v5.6.0
ARG SUPERBUILD_TAG=v5.6.0
ARG SUPERBUILD_REPO=https://gitlab.kitware.com/paraview/paraview-superbuild.git

RUN apt-get update && apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        build-essential \
        ca-certificates \
        chrpath \
        curl \
        gfortran \
        git \
        libtool \
        openssl \
        python2.7-dev \
        python-pip \
        python-setuptools \
        pkg-config && \
    rm -rf /var/lib/apt/lists/* && \
    pip install mako

# Create a non-root user
RUN groupadd pv-user && \
    useradd -g pv-user -d /home/pv-user pv-user && \
    mkdir /home/pv-user && chown -R pv-user:pv-user /home/pv-user && \
    mkdir -p /opt/paraview && chown -R pv-user:pv-user /opt/paraview

USER pv-user

# Get CMake, then clone the ParaView superbuild project
RUN mkdir -p /home/pv-user/cmake/3.13.4 && cd /home/pv-user/cmake/3.13.4 && \
    curl -L https://cmake.org/files/v3.13/cmake-3.13.4-Linux-x86_64.tar.gz | tar --strip-components=1 -xzv && \
    mkdir -p /home/pv-user/pvsb && cd /home/pv-user/pvsb && \
    git clone --recursive ${SUPERBUILD_REPO} src && \
    cd src && git checkout ${SUPERBUILD_TAG} && git submodule update && cd .. && \
    mkdir build && cd build && \
    /home/pv-user/cmake/3.13.4/bin/cmake -C /home/pv-user/pvsb/src/cmake/sites/Docker-Ubuntu-18_04.cmake "-GUnix Makefiles" ../src && \
    make -j"$(nproc)" install && \
    rm -rf /home/pv-user/pvsb && rm -rf /home/pv-user/cmake

WORKDIR /opt/paraview
