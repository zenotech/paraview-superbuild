#!/bin/sh

set -e
set -x

usage () {
    echo "Usage: $0 <version> <index tarball> [count]" >&2
    exit 0
}

readonly version="$1"
shift || usage

readonly tarball="$1"
shift || usage

if [ -n "$1" ]; then
    count_suffix=".$1"
    shift
else
    count_suffix=
fi
readonly count_suffix

readonly dirname="$( basename "$tarball" ".tgz" )"
readonly date="$( date "+%Y%m%d" )"

tar xf "$tarball"
cd "$dirname"

readonly dirprefix="nvidia-index-libs-$version.$date$count_suffix"
readonly linux_dir="$dirprefix-linux"
readonly windows_dir="$dirprefix-windows-x64"

mkdir "$linux_dir" "$windows_dir"

mv "linux-x86-64/lib" "$linux_dir/"
mv "nt-x86-64/lib" "$windows_dir/"

cp EULA.pdf license.txt README.txt "$linux_dir/"
cp EULA.pdf license.txt README.txt "$windows_dir/"

chmod -R a+rX "$linux_dir" "$windows_dir"
tar cjf "../$linux_dir.tar.bz2" "$linux_dir"
tar cjf "../$windows_dir.tar.bz2" "$windows_dir"

rm -rf "$dirname"
