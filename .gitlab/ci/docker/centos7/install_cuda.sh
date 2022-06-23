#!/bin/sh

set -e

# Install the nvidia repository.
yum-config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo

# Install CUDA toolchains.
yum install -y \
    cuda-compiler-11-2 cuda-cudart-devel-11-2 cuda-toolkit-11-2

yum clean all
