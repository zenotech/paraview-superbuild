#!/bin/sh

set -e
set -x

usage () {
    echo "Usage: $0 <version> <index tarball> [suffix]" >&2
    exit 0
}

readonly version="$1"
shift || usage

readonly tarball="$1"
shift || usage

if [ -n "$1" ]; then
    count_suffix="$1"
    shift
else
    count_suffix=
fi
readonly count_suffix

readonly dirname="$( basename "$tarball" ".tgz" )"
readonly date="$( date "+%Y%m%d" )"

tar xf "$tarball"
chmod -R u+rw "$dirname"
cd "$dirname"

readonly dirprefix="nvidia-index-libs-$version.$date$count_suffix"

for arch in linux-x86-64 linux-ppc64le nt-x86-64; do
    case $arch in
        linux-x86-64)
            dir="$dirprefix-linux"
            ;;
        linux-ppc64le)
            if ! [ -d "$arch" ]; then
                # This architecture is optional, ignore if it's missing from the tarball.
                continue
            fi
            dir="$dirprefix-linux-ppc64le"
            ;;
        nt-x86-64)
            dir="$dirprefix-windows-x64"
            ;;
        *)
            echo "Unsupported arch '$arch'"
            exit 1
            ;;
    esac

    mkdir "$dir"

    mv "$arch/lib" "$dir/"
    cp EULA.pdf license.txt README.txt "$dir/"

    chmod -R a+rX "$dir"
    tar cjf "../$dir.tar.bz2" "$dir"
done

rm -rf "$dirname"
