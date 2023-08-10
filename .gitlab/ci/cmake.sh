#!/bin/sh

set -e

readonly version="3.26.5"

case "$( uname -s )" in
    Linux)
        shatool="sha256sum"
        sha256sum="130941ae3ffe4a9ee3395514787115a273a8d1ce15cb971494bb45f7e58bb3c3"
        platform="linux-x86_64"
        ;;
    Darwin)
        shatool="shasum -a 256"
        sha256sum="1f32de002cc1b927782dd56fff97638919fe9e71dde56e2e85ced69c0356371e"
        platform="macos-universal"
        ;;
    *)
        echo "Unrecognized platform $( uname -s )"
        exit 1
        ;;
esac
readonly shatool
readonly sha256sum
readonly platform

readonly filename="cmake-$version-$platform"
readonly tarball="$filename.tar.gz"

cd .gitlab

echo "$sha256sum  $tarball" > cmake.sha256sum
curl -OL "https://github.com/Kitware/CMake/releases/download/v$version/$tarball"
$shatool --check cmake.sha256sum
tar xf "$tarball"
mv "$filename" cmake

if [ "$( uname -s )" = "Darwin" ]; then
    ln -s CMake.app/Contents/bin cmake/bin
fi
