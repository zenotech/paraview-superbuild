FROM fedora:33
MAINTAINER Utkarsh Ayachit <utkarsh.ayachit@kitware.com>

RUN dnf install --setopt=install_weak_deps=False -y \
  /usr/bin/glxinfo git mesa-dri-drivers mesa-libGL* \
  libXcursor-devel libxcrypt-compat.x86_64 libxkbcommon \
  libxkbcommon-x11 \
  && dnf clean all
