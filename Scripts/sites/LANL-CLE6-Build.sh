#!/bin/bash

if [ $# -lt 4 ]
then
  echo "Usage: $0 compiler compiler_version mpi mpi_version [extra cmake args]"
  exit 1
fi

COMP=$1
COMP_VER=$2
MPI=$3
MPI_VER=$4

shift 4

case "${COMP}" in
  intel)
    COMP_MOD=intel
    PE_MOD=intel
    ;;
  gcc|gnu)
    COMP_MOD=gcc
    PE_MOD=gnu
    ;;
  *)
    COMP_MOD=${COMP}
    PE_MOD=${COMP}
    ;;
esac

module purge
module load craype
module load craype-haswell
module load PrgEnv-${PE_MOD}
module swap ${COMP_MOD} ${COMP_MOD}/${COMP_VER}
module load ${MPI}/${MPI_VER}
module load cray-hdf5
module load friendly-testing cmake/3.6.1 git/2.3.3

export CC=$(which cc) CXX=$(which CC) FC=$(which ftn)
export CRAYPE_LINK_TYPE=dynamic

BASENAME=5.1.2-osmesa_${COMP}-${COMP_VER}_${MPI}-${MPI_VER}
SRC=$(readlink -f $(dirname $(readlink -f $0))/../..)
DOWNLOADS=${PWD}/downloads

mkdir -p ${BASENAME}
cd ${BASENAME}

cmake \
  -Dsuperbuild_download_location=${DOWNLOADS} \
  -DPARAVIEWSDK_PACKAGE_FILE_NAME=${BASENAME} \
  -C${SRC}/cmake/sites/LANL-CLE6-Shared.cmake \
  -DSUPERBUILD_PROJECT_PARALLELISM=10 \
  "$@" ${SRC}
make
ctest -R cpack-paraviewsdk-TGZ
