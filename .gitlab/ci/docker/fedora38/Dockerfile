FROM fedora:38
MAINTAINER Ben Boeckel <ben.boeckel@kitware.com>

RUN dnf install --setopt=install_weak_deps=False -y \
  /usr/bin/glxinfo git mesa-dri-drivers mesa-libGL* \
  libXcursor-devel libxcrypt-compat libxkbcommon \
  libxkbcommon-x11 xcb-util-image xcb-util-wm xcb-util xcb-util-image \
  xcb-util-keysyms xcb-util-renderutil file \
  && dnf clean all
