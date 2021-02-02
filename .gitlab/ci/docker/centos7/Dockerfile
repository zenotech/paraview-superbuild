FROM centos:7
MAINTAINER Utkarsh Ayachit <utkarsh.ayachit@kitware.com>

COPY install_deps.sh /root/install_deps.sh
RUN sh /root/install_deps.sh

COPY install_cuda.sh /root/install_cuda.sh
RUN sh /root/install_cuda.sh
