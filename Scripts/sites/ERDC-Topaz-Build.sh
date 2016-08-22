#!/bin/bash

if [ $# -ne 4 ]
then
  echo "Usage: $0 compiler compiler_version mpi mpi_version"
  exit 1
fi

COMP=$1
COMP_VER=$2
MPI=$3
MPI_VER=$4

module purge 1>/dev/null 2>&1
module load compiler/${COMP}/${COMP_VER}
module load mpi/${MPI}/${MPI_VER}

case $COMP in
  gcc)
    COST_MOD=gnu
    ;;
  intel)
    COST_MOD=intel

    # Use a different GCC root to get C++11 working
    export PATH=/apps/gnu_compiler/4.8.5/bin:$PATH
    ;;
  *)
    ;;
esac

module load costinit
module load boost/${COST_MOD}/1.58.0
module load python/${COST_MOD}/2.7.10
module load numpy/${COST_MOD}/1.9.2
module load matplotlib/${COST_MOD}/1.4.3
module load hdf5/${COST_MOD}/1.8.15

BASENAME=5.1.2-osmesa_${COMP}-${COMP_VER}_${MPI}-${MPI_VER}
SRC=$(readlink -f $(dirname $(readlink -f $0))/../..)
DOWNLOADS=${PWD}/downloads

mkdir -p ${BASENAME}
cd ${BASENAME}

~/Code/CMake/build/bin/cmake \
  -Dsuperbuild_download_location=${DOWNLOADS} \
  -DPARAVIEWSDK_PACKAGE_FILE_NAME=${BASENAME} \
  -C${SRC}/cmake/sites/ERDC-Topaz.cmake \
  -DSUPERBUILD_PROJECT_PARALLELISM=14 \
  ${SRC}
make
~/Code/CMake/build/bin/ctest -R cpack-paraviewsdk-TGZ
