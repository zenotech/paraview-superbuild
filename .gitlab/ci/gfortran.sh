#!/bin/sh

set -e

readonly gcc_version="13.2"
readonly version="$gcc_version-darwin-r0-20230829.0"

case "$(uname -m)" in
    x86_64)
        sha256sum="f163791037d16cda6f382f7ae2673ada84199948ae9f1d4d70bb99335628c099"
        platform="macos10.13-x86_64"
        ;;
    arm64)
        sha256sum="169e6647c7d79fd443b1b88f36c99e28a5c53b0b1bcd159c669851af778afb1a"
        platform="macos11.0-aarch64"
        ;;
    *)
        echo "Unrecognized platform $( uname -m )"
        exit 1
        ;;
esac
readonly sha256sum
readonly platform

readonly tarball="gcc-$gcc_version-$platform.tar.xz"

cd .gitlab

echo "$sha256sum  $tarball" > gfortran.sha256sum
curl -OL "https://gitlab.kitware.com/api/v4/projects/6955/packages/generic/gfortran-macos/v$version/$tarball"
shasum -a 256 --check gfortran.sha256sum
mkdir gfortran
tar --strip-components=3 -C gfortran -xf "$tarball"
