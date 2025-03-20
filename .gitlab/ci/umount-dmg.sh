#!/bin/sh

set -e

if ! [ -d "build/__mount" ]; then
    exit 0
fi

# Detach the mount point.
if ! hdiutil detach -verbose "build/__mount"; then
    echo "Failed to detach mounted image…forcing"
    hdiutil detach -force -verbose "build/__mount"
fi
