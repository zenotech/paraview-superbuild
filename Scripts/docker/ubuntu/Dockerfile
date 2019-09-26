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
#   DEV_BUILD
#
#     false
#     true
#
#     (default is "false" -> build tree and cmake are removed)
#
#   PYTHON_VERSION
#
#     2
#     3
#
#     (default is "2")
#

ARG BASE_IMAGE=nvidia/opengl:1.0-glvnd-devel-ubuntu18.04
FROM ${BASE_IMAGE}

ARG RENDERING=egl
ARG PARAVIEW_TAG=v5.7.0
ARG SUPERBUILD_TAG=v5.7.0
ARG SUPERBUILD_REPO=https://gitlab.kitware.com/paraview/paraview-superbuild.git
ARG DEV_BUILD=false
ARG PYTHON_VERSION=2

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
        ca-certificates \
        chrpath \
        curl \
        gfortran \
        git \
        libtool \
        openssl \
        pkg-config && \
    if [ "${PYTHON_VERSION}" = "2" ]; then apt-get install -y --no-install-recommends python2.7-dev python-pip python-setuptools; fi && \
    if [ "${PYTHON_VERSION}" = "3" ]; then apt-get install -y --no-install-recommends python3-dev python3-pip python3-setuptools; fi && \
    rm -rf /var/lib/apt/lists/* && \
    ${!SYSTEM_PYTHON_PIP} install mako

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
    if [ "${DEV_BUILD}" != "true" ] ; then rm -rf /home/pv-user/pvsb && rm -rf /home/pv-user/cmake ; fi

WORKDIR /opt/paraview
