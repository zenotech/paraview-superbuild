#!/bin/sh

set -e

# mirrorlist.centos.org no longer exists because el8 is past end of life.
# To get packages, replace mirrorlist with baseurl and change mirror.centos.org
# to vault.centos.org.
# sed -i \
#     -e s/mirror.centos.org/vault.centos.org/g \
#     -e s/^#.*baseurl=http/baseurl=http/g \
#     -e s/^mirrorlist=http/#mirrorlist=http/g \
#     /etc/yum.repos.d/CentOS-*.repo

# Install EPEL
dnf install -y \
    epel-release

# Install tools to manage repositories.
dnf install -y --setopt=install_weak_deps=False \
    'dnf-command(config-manager)'

dnf config-manager --set-enabled powertools

# Install build requirements.
dnf install -y --setopt=install_weak_deps=False \
    freeglut-devel glew-devel graphviz-devel \
    libxcb-devel libXt-devel xcb-util-wm-devel xcb-util-devel \
    xcb-util-image-devel xcb-util-keysyms-devel xcb-util-renderutil-devel \
    xcb-util-cursor libXcursor-devel mesa-libGL-devel mesa-libEGL-devel \
    libxkbcommon-devel libxkbcommon-x11-devel file mesa-dri-drivers autoconf \
    automake libtool chrpath bison flex libXrandr-devel \
    alsa-lib-devel mesa-vulkan-devel

# Install development tools
dnf install -y --setopt=install_weak_deps=False \
    git-lfs

# Install toolchains.
dnf install -y --setopt=install_weak_deps=False \
    gcc-toolset-10-toolchain \
    gcc-toolset-10-gcc \
    gcc-toolset-10-gcc-c++ \
    gcc-toolset-10-gcc-gfortran

# sed -i \
#     -e s/mirror.centos.org/vault.centos.org/g \
#     -e s/^#.*baseurl=http/baseurl=http/g \
#     -e s/^mirrorlist=http/#mirrorlist=http/g \
#     /etc/yum.repos.d/CentOS-*.repo

dnf clean all
