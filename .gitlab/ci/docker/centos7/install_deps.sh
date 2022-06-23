#!/bin/sh

set -e

# Install build requirements.
yum install -y \
    zlib-devel libcurl-devel python-devel \
    freeglut-devel glew-devel graphviz-devel libpng-devel \
    libxcb libxcb-devel libXt-devel xcb-util xcb-util-devel \
    libXcursor-devel mesa-libGL-devel mesa-libEGL-devel \
    libxkbcommon-devel libxkbcommon-x11-devel file mesa-dri-drivers autoconf \
    automake libtool chrpath bison flex libXrandr-devel

# Install EPEL
yum install -y \
    epel-release

# Install IUS (for newer git)
yum install -y \
    https://repo.ius.io/ius-release-el7.rpm

# Install development tools
yum install -y \
    git224-core \
    git-lfs

# Install toolchains.
yum install -y \
    centos-release-scl
yum install -y \
    devtoolset-7-gcc-c++ \
    devtoolset-7 \
    devtoolset-7-gcc \
    devtoolset-7-gfortran

yum clean all
