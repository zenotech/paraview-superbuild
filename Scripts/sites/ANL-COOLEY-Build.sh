#!/bin/bash

if [ $# -lt 3 ]
then
  echo "Usage: $0 compiler mpi boost [extra cmake args]"
  echo "We recommend +gcc-4.8.1 +mvapich2-2.1 +boost-1.57.0-gcc-mvapich2"
  exit 1
fi

COMP=$1
MPI=$2
BOOST=$3
shift 3

source ${SOFTENV_ALIASES}
soft add +cmake-3.8.1
soft add +git
soft add ${MPI}
soft add ${COMP}
soft add ${BOOST}

# The paths get mucked with a bit later so this just makes sure we use the
# right compiler when CMake is called
case ${COMP} in
  +gcc*)
    export CC=$(which gcc) CXX=$(which g++) FC=$(which gfortran)
    ;;
  *)
    echo "Warning, that compiler is untested. You must set CC, CXX, and FC environment variables."
esac

BASENAME=v5.4.0_${COMP}_${MPI}
SRC=$(readlink -f $(dirname $(readlink -f $0))/../..)
DOWNLOADS=${PWD}/downloads

mkdir -p ${BASENAME}
cd ${BASENAME}

# Set any user supplied values
EXTRA_OPTS="${EXTRA_OPTS}"

# Place newer binutils in the path for AVX2 code generation
soft add +binutils-2.27

echo ${BASENAME} > log.configure
cmake \
  -DPARAVIEWSDK_PACKAGE_FILE_NAME=${BASENAME} \
  -C${SRC}/cmake/sites/ANL-Cooley-Shared.cmake \
  ${EXTRA_OPTS} "$@" ${SRC} 2>&1 | tee -a log.configure
if [ $? -ne 0 ]
then
  exit 1
fi

echo ${BASENAME} > log.build
make 2>&1 | tee -a log.build
if [ $? -ne 0 ]
then
  exit 1
fi

echo ${BASENAME} > log.package
ctest -R cpack-paraviewsdk-TGZ 2>&1 | tee -a log.package
if [ $? -ne 0 ]
then
  exit 1
fi
