#!/bin/sh

set -e

# Install build requirements.
yum install -y \
    freeglut-devel glew-devel graphviz-devel \
    libxcb-devel libXt-devel xcb-util-wm-devel xcb-util-devel \
    xcb-util-image-devel xcb-util-keysyms-devel xcb-util-renderutil-devel \
    libXcursor-devel mesa-libGL-devel mesa-libEGL-devel \
    libxkbcommon-devel libxkbcommon-x11-devel file mesa-dri-drivers autoconf \
    automake libtool chrpath bison flex libXrandr-devel \
    alsa-lib-devel

# Install EPEL
yum install -y \
    epel-release

# Install development tools
yum install -y \
    git-lfs

# Install toolchains.
yum install -y \
    centos-release-scl
yum install -y \
    devtoolset-10-gcc-c++ \
    devtoolset-10 \
    devtoolset-10-gcc \
    devtoolset-10-gfortran \
    rh-git227-git-core

yum clean all
