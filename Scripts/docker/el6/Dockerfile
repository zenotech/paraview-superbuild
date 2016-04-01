FROM centos:6
MAINTAINER Chuck Atkins <chuck.atkins@kitware.com>

# Install some extra core system utilities and editors
RUN yum install -y \
    file tar xz bzip2 \
    wget screen vim-enhanced vim-filesystem emacs

# Install development tools and X libraries
RUN yum install -y \
    gcc gcc-c++ gcc-gfortran \
    git subversion libtool automake scons \
    libX11-devel libXdamage-devel libXext-devel libXt-devel libXi-devel \
    libxcb-devel xorg-x11-xtrans-devel libXcursor-devel libXft-devel \
    libXinerama-devel libXrandr-devel libXrender-devel \
    mesa-libGL-devel mesa-libOSMesa-devel mesa-libGLU-devel

# Install some additional convienient utilities from the EPEL repo
RUN yum install -y epel-release && \
    yum install -y htop pbzip2

# Install a newer set of compilers from the Software Collections repos
RUN yum install -y centos-release-scl && \
  yum install -y \
    devtoolset-3-gcc devtoolset-3-gcc-c++ devtoolset-3-gcc-gfortran python27

# Cleanup
RUN yum clean all

# Install the most recent CMake release
RUN mkdir -p /tmp/cmake && \
  git clone -b release git://cmake.org/cmake.git /tmp/cmake/source && \
  mkdir -p /tmp/cmake/build && cd /tmp/cmake/build && \
  /tmp/cmake/source/bootstrap --parallel=8 && make -j8 install && \
  cd / && rm -rf /tmp/cmake

# Create the shared mount point
RUN mkdir -p /mnt/shared
