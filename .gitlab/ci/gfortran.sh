#!/bin/sh

set -e

readonly gcc_version="12.2"
readonly version="$gcc_version-darwin-r0-20220922.0"

case "$(uname -m)" in
    x86_64)
        sha256sum="bd7bd769e4c5ab11ebfb1513873ca1df7e906f540a247021e243d701fe878ceb"
        platform="macos10.13-x86_64"
        ;;
    arm64)
        sha256sum="b86a460a57889d1faf8e455a2b3ecfe4098e10d5843b4ba6a55daed764fd009c"
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
