#!/bin/bash

# Make sure the shared mount point exists
BASE_DIR=$(dirname $(readlink -f ${BASH_SOURCE}))
mkdir -p ${BASE_DIR}/shared
chmod 6755 ${BASE_DIR}/shared

# The first 3 sets of arguments lets the container use the X server on the host
# The next mounts a shared directory between the container and host
# Next, the add-host argument just makes accessing the host more convenient
X=$(echo ${DISPLAY} | sed 's|.*:\([0-9]*\)\.[0-9]*|\1|')
IP=$(ip addr show docker0 | sed -n 's|.*inet \([0-9\.]*\).*|\1|p')
docker run -i \
  --env="DISPLAY" \
  --volume="/tmp/.X11-unix/X${X}:/tmp/.X11-unix/X${X}:rw" \
  --volume="${HOME}/.Xauthority:/root/.Xauthority:rw" \
  --volume="${BASE_DIR}/shared:/mnt/shared:rw" \
  --add-host="${HOSTNAME}:${IP}" --hostname=paraview-el6-build \
  -t paraview-el6-build \
  /bin/bash --login
