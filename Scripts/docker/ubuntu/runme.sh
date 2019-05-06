#!/bin/bash

# If you want to run the OSMesa version, no runtime arg is needed:
docker run --rm -ti pv-v5.6.0-osmesa

# Or if you have nvidia-docker2 installed and want to run the egl version:
# docker run --rm --runtime=nvidia -ti pv-v5.6.0-egl
