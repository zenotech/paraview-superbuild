#!/bin/sh

set -e

# Install the nvidia repository.
dnf config-manager --add-repo \
    https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-rhel8.repo

# Install CUDA toolchains.
dnf install -y \
    cuda-compiler-12-6 cuda-cudart-devel-12-6 cuda-toolkit-12-6

dnf clean all
