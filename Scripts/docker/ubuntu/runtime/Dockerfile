
#
# This Dockerfile allows copying only the ParaView install tree from the
# development image.  To be sure the resulting paraview binaries work, you
# must still use, as the second-stage base image, the same base image used
# to build the development image.
#
# To build this image:
#
#     $ docker build \
#         --build-arg PV_DEV_BASE_IMAGE=pv-v5.7.1-egl-py3-dev \
#         -t pv-v5.7.1-egl-py3-rel \
#         .
#
# To customize the image used as the second-stage base, use the `BASE_IMAGE`
# build argument:
#
#     $ docker build \
#         --build-arg PV_DEV_BASE_IMAGE=pv-v5.7.1-egl-py3-dev \
#         --build-arg BASE_IMAGE=nvidia/opengl:1.0-glvnd-devel-ubuntu18.04 \
#         -t pv-v5.7.1-egl-py3-rel \
#         .
#

ARG BASE_IMAGE=nvidia/opengl:1.0-glvnd-devel-ubuntu18.04
ARG PV_DEV_BASE_IMAGE=pv-dev-image

# Start with the pv development image so we can copy from it
FROM ${PV_DEV_BASE_IMAGE} AS devimage

# Now pick the base of that image as our new base
FROM ${BASE_IMAGE} AS baseimage

# Now install python the same same way we did in the base
ARG PYTHON_VERSION=2

# The following environment variables help with the Python 2 vs 3 option while
# we still support both of them.  In order for this approach to work, we need
# the RUN command to use bash instead of sh for variable indirection.
SHELL ["/bin/bash", "-c"]

ENV SYSTEM_PYTHON_2_PIP pip
ENV SYSTEM_PYTHON_3_PIP pip3
ENV SYSTEM_PYTHON_PIP "SYSTEM_PYTHON_${PYTHON_VERSION}_PIP"

RUN apt-get update && \
    if [ "${PYTHON_VERSION}" = "2" ]; then apt-get install -y --no-install-recommends python2.7-dev python-pip python-setuptools; fi && \
    if [ "${PYTHON_VERSION}" = "3" ]; then apt-get install -y --no-install-recommends python3-dev python3-pip python3-setuptools; fi && \
    if [ "${PYTHON_VERSION}" = "3" ]; then update-alternatives --install /usr/bin/python python /usr/bin/python3 1; fi && \
    rm -rf /var/lib/apt/lists/*

# Re-create the non-root user we had in development image
RUN groupadd pv-user && \
    useradd -g pv-user -d /home/pv-user pv-user && \
    mkdir /home/pv-user && chown -R pv-user:pv-user /home/pv-user

# Now copy the installed paraview from the development image, using
# the non-root user as the owner.
COPY --from=devimage --chown=pv-user:pv-user /opt/paraview /opt/paraview

USER pv-user
WORKDIR /opt/paraview
