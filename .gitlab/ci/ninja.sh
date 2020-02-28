#!/bin/sh

set -e

readonly version="1.9.0.g99df1.kitware.dyndep-1.jobserver"
readonly sha256sum="15d1315616b97142217bd18e88ddd5f60a1ff5c14a19e22a4bf50681898cf53c"
readonly filename="ninja-$version-1_x86_64-linux-gnu"
readonly tarball="$filename.tar.gz"

cd .gitlab

echo "$sha256sum  $tarball" > ninja.sha256sum
curl -OL "https://github.com/Kitware/ninja/releases/download/v$version-1/$tarball"
sha256sum --check ninja.sha256sum
tar xf "$tarball"
mv "$filename/ninja" .
