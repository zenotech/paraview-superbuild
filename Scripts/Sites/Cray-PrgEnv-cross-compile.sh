#!/bin/bash

if [ $# -ne 4 ]
then
  echo "Usage: $0 gnu|intel /path/to/cmake download_dir install_dir"
  exit 1
fi

COMP=$1
CMAKE=$2
DOWN=$3
INST=$4
SRC=$(readlink -f $(dirname $BASH_SOURCE)/../..)


# Old cray environments use the ASYNCPE_VERSION env var and need slightly
# different modules
#
# Note: substitute craype-mc8 or craype-haswell with whatever CPU module
# your compute nodes need
if [ "x${ASYNCPE_VERSION}x" != "xx" ]
then
  echo "Loading modules for (older) Cray Programming Environment"
  CPU=${CRAY_CPU_TARGET}
elif [ "x${CRAYPE_VERSION}x" != "xx" ]
then
  echo "Loading modules for (newer) Cray Programming Environment"
  CPU=${CRAY_CPU_TARGET}
  EXTRA_MODULES=craype
else
  echo "Error: can't identify the right Cray OS version to load modules for"
  exit 2
fi

. /opt/modules/default/init/bash
module purge 1>/dev/null 2>/dev/null
module load modules ${EXTRA_MODULES} gcc PrgEnv-${COMP} craype-${CPU} cray-mpich cray-hdf5

export CC=gcc
export CXX=g++
export FC=gfortran

mkdir tools
cd tools
${CMAKE} \
  -DCROSS_BUILD_STAGE:STRING=TOOLS -Dcross_target:STRING=cray_prgenv \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DBUILD_TESTING:BOOL=FALSE \
  -DParaView_FROM_GIT:BOOL=OFF \
  -DENABLE_paraview:BOOL=TRUE \
  -DENABLE_boost:BOOL=TRUE \
  -DENABLE_python:BOOL=TRUE \
  -DENABLE_zlib:BOOL=TRUE \
  -DUSE_SYSTEM_zlib:BOOL=TRUE \
  -DENABLE_png:BOOL=TRUE \
  -DUSE_SYSTEM_png:BOOL=TRUE \
  -DENABLE_bzip2:BOOL=TRUE \
  -DUSE_SYSTEM_bzip2:BOOL=TRUE \
  -Ddownload_location:PATH=${DOWN} \
  ${SRC}
make

unset CC
unset CXX
unset FC
cd ..
mkdir cross
cd cross
${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${INST} \
  -DCROSS_BUILD_STAGE:STRING=CROSS -Dcross_target:STRING=cray_prgenv \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DBUILD_TESTING:BOOL=OFF \
  -DParaView_FROM_GIT:BOOL=OFF \
  -DENABLE_paraview:BOOL=TRUE \
  -DENABLE_paraviewsdk:BOOL=TRUE \
  -DENABLE_python:BOOL=TRUE \
  -DENABLE_mesa:BOOL=TRUE \
  -Ddownload_location:PATH=${DOWN} \
  -DPV_MAKE_NCPUS=12 \
  ${SRC}
make
make install
