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
#   PYTHON_VERSION
#
#     3
#
#     (default is "2")
#
#   BUILD_TYPE
#
#     "Release", or "Debug" (Default: "Release")
#

ARG BASE_IMAGE=nvidia/opengl:1.0-glvnd-devel-ubuntu18.04
FROM ${BASE_IMAGE}

ARG RENDERING=egl
ARG PARAVIEW_TAG=v5.11.1
ARG SUPERBUILD_TAG=v5.11.1
ARG PARAVIEW_VERSION_STRING=paraview-5.11
ARG SUPERBUILD_REPO=https://gitlab.kitware.com/paraview/paraview-superbuild.git
ARG PYTHON_VERSION=3
ARG BUILD_TYPE=Release

# The following environment variables help with the Python 2 vs 3 option while
# we still support both of them.  In order for this approach to work, we need
# the RUN command to use bash instead of sh for variable indirection.
SHELL ["/bin/bash", "-c"]

ENV SYSTEM_PYTHON_2_PIP pip
ENV SYSTEM_PYTHON_3_PIP pip3
ENV SYSTEM_PYTHON_PIP "SYSTEM_PYTHON_${PYTHON_VERSION}_PIP"

RUN apt-get update && apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        build-essential \
        byacc \
        ca-certificates \
        chrpath \
        curl \
        gfortran \
        git \
        libtool \
        libxcursor-dev \
        openssl \
        pkg-config && \
    if [ "${PYTHON_VERSION}" = "3" ]; then apt-get install -y --no-install-recommends python3-dev python3-pip python3-setuptools; fi && \
    if [ "${PYTHON_VERSION}" = "3" ]; then update-alternatives --install /usr/bin/python python /usr/bin/python3 1; fi && \
    rm -rf /var/lib/apt/lists/* && \
    ${!SYSTEM_PYTHON_PIP} install mako

# Create a non-root user
RUN groupadd pv-user && \
    useradd -g pv-user -d /home/pv-user pv-user && \
    mkdir /home/pv-user && chown -R pv-user:pv-user /home/pv-user && \
    mkdir -p /opt/paraview && chown -R pv-user:pv-user /opt/paraview

USER pv-user

# Get CMake
RUN mkdir -p /home/pv-user/cmake/3.18.6 && cd /home/pv-user/cmake/3.18.6 && \
    curl -L https://cmake.org/files/v3.18/cmake-3.18.6-Linux-x86_64.tar.gz | tar --strip-components=1 -xzv

# Make it easy to find CMake when build external projects and plugins
ENV CMAKE_EXECUTABLE "/home/pv-user/cmake/3.18.6/bin/cmake"
ENV PATH             "/home/pv-user/cmake/3.18.6/bin:${PATH}"

# Clone the superbuild
RUN mkdir -p /home/pv-user/pvsb/build && cd /home/pv-user/pvsb && \
    git clone --recursive ${SUPERBUILD_REPO} src && \
    cd src && git checkout ${SUPERBUILD_TAG} && git submodule update

WORKDIR /home/pv-user/pvsb/build

# Configure
RUN ${CMAKE_EXECUTABLE} -C /home/pv-user/pvsb/src/cmake/sites/Docker-Ubuntu-18_04.cmake "-GUnix Makefiles" ../src

# Build
RUN ${CMAKE_EXECUTABLE} --build .

# Install
RUN ${CMAKE_EXECUTABLE} --install .

# Make it easy to find ParaView when build external projects and plugins
env PARAVIEW_DIRECTORY /home/pv-user/pvsb/build/install/lib/cmake/${PARAVIEW_VERSION_STRING}

WORKDIR /opt/paraview
