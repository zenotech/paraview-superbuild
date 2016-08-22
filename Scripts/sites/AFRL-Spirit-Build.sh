#!/bin/bash

if [ $# -lt 4 ]
then
  echo "Usage: $0 compiler compiler_version mpi mpi_version"
  exit 1
fi

COMP=$1
COMP_VER=$2
MPI=$3
MPI_VER=$4
shift 4

case $COMP in
  gcc)
    COMP_MOD=compiler/gcc
    COST_MOD=gnu
    ;;
  intel)
    COMP_MOD=compiler/intel
    COST_MOD=intel
    ;;
  *)
    COMP_MOD=${COMP}
    COST_MOD=${COMP}
    ;;
esac

case "${MPI}" in
  impi|intel-mpi*)
    MPI_MOD=$(module avail intel-mpi 2>&1 | grep -o "intel-mpi[^/]*/${MPI_VER}" | sed 's|\([^/]*\)/.*|\1|')
    MPI=impi
    ;;
  mpt|sgimpt)
    MPI_MOD=mpt
    MPI=sgimpt
    ;;
  *)
    MPI_MOD=${MPI}
    ;;
esac

module purge 1>/dev/null 2>&1
module load costinit
module load /app/startup/shell.module

module load ${COMP_MOD}/${COMP_VER}
module load ${MPI_MOD}/${MPI_VER}
module load binutils/2.23

module load git
module load lapack/${COST_MOD}/3.5.0
module load hdf5/${COST_MOD}/1.8.15

module list

BASENAME=5.1.2-osmesa_${COMP}-${COMP_VER}_${MPI}-${MPI_VER}
SRC=$(readlink -f $(dirname $(readlink -f $0))/../..)
DOWNLOADS=${PWD}/downloads

mkdir -p ${BASENAME}
cd ${BASENAME}

if [ "${COMP}" == "intel" ]
then
  # Also load GCC to get proper C++11 support
  module load gcc-compilers/4.8.4
  export CC=icc CXX=icpc FC=ifort

  if [ "${MPI}" == "impi" ]
  then
    export MPICC=mpiicc MPICXX=mpiicpc MPIFC=mpiifort
    MPI_C_ARGS="-DMPI_C_COMPILER:FILEPATH=$(which mpiicc)"
    MPI_CXX_ARGS="-DMPI_CXX_COMPILER:FILEPATH=$(which mpiicpc)"
    MPI_F_ARGS="-DMPI_Fortran_COMPILER:FILEPATH=$(which mpiifort)"
  fi
fi

~/Code/CMake/build/master/bin/cmake \
  -DPARAVIEWSDK_PACKAGE_FILE_NAME=${BASENAME} \
  -C${SRC}/cmake/sites/AFRL-Spirit.cmake \
  ${MPI_C_ARGS} ${MPI_CXX_ARGS} ${MPI_F_ARGS} \
  "$@" ${SRC} 2>&1 | tee log.configure
make 2>&1 | tee log.build
~/Code/CMake/build/master/bin/ctest -R cpack-paraviewsdk-TGZ 2>&1 | tee log.package
