#!/bin/bash

if [ $# -lt 5 ]
then
  echo "Usage: $0 compiler cpu compiler_version mpi mpi_version [extra cmake args]"
  exit 1
fi

CPU=$1
COMP=$2
COMP_VER=$3
MPI=$4
MPI_VER=$5

shift 4

case "${COMP}" in
  gcc|gnu)
    COMP_MOD=gcc
    PE_MOD=gnu
    ;;
  *)
    COMP_MOD=${COMP}
    PE_MOD=${COMP}
    ;;
esac

case "${MPI}" in
  cray|craympt)
    MPI=craympt
    MPI_MOD=cray-mpich
    ;;
  *)
    MPI_MOD=${MPI}
    ;;
esac

module purge
module load craype
module load craype-${CPU}
module load PrgEnv-${PE_MOD}
module swap ${COMP_MOD} ${COMP_MOD}/${COMP_VER}
module load ${MPI_MOD}/${MPI_VER}
module load cray-hdf5
module load cray-libsci

if [ "${COMP_MOD}" != "gcc" ]
then
  # Also load GCC to get proper C++11 support
  module load gcc/4.8.2
fi
module list

export CC=$(which cc) CXX=$(which CC) FC=$(which ftn)
export CRAYPE_LINK_TYPE=dynamic

BASENAME=5.1.2-osmesa_${COMP}-${COMP_VER}_${MPI}-${MPI_VER}
SRC=$(readlink -f $(dirname $(readlink -f $0))/../..)

mkdir -p ${BASENAME}
cd ${BASENAME}

export TMPDIR=/tmp/$USER
mkdir -p ${TMPDIR}

~/Code/CMake/build/master/bin/cmake \
  -DPARAVIEWSDK_PACKAGE_FILE_NAME=${BASENAME} \
  -C${SRC}/cmake/sites/DoD-CLE5-Shared.cmake \
  -DSUPERBUILD_PROJECT_PARALLELISM=10 \
  "$@" ${SRC} 2>&1 | tee log.configure
if [ ${PIPESTATUS[0]} -ne 0 ]
then
  exit 1
fi

make 2>&1 | tee log.build
if [ ${PIPESTATUS[0]} -ne 0 ]
then
  exit 1
fi

~/Code/CMake/build/master/bin/ctest -V -R cpack-paraviewsdk-TGZ 2>&1 | tee log.package
if [ ${PIPESTATUS[0]} -ne 0 ]
then
  exit 1
fi

rm -rf ${TMPDIR}
