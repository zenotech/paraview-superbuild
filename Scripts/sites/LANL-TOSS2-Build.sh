#!/bin/bash

if [ $# -lt 6 ]
then
  echo "Usage: $0 compiler compiler_version mpi mpi_version swr ospray [extra cmake args]"
  exit 1
fi

COMP=$1
COMP_VER=$2
MPI=$3
MPI_VER=$4
SWR=$5
OSPRAY=$6
shift 6

case ${COMP} in
  *)
    COMP_MOD=${COMP}
    ;;
esac

case "${MPI}" in
  impi|intel|intel-mpi*)
    MPI_MOD=intel-mpi
    MPI=impi
    ;;
  *)
    MPI_MOD=${MPI}
    ;;
esac

module purge
module load friendly-testing
module load cmake/3.6.1 git/2.3.3
module load ${COMP_MOD}/${COMP_VER}
module load ${MPI_MOD}/${MPI_VER}

module list

# The paths get mucked with a bit later so this just makes sure we use the
# right compiler when CMake is called
case ${COMP} in
  intel)
    export CC=$(which icc) CXX=$(which icpc) FC=$(which ifort)
    ;;
  gcc)
    export CC=$(which gcc) CXX=$(which g++) FC=$(which gfortran)
    ;;
esac

BASENAME=5.1.2-osmesa_${COMP}-${COMP_VER}_${MPI}-${MPI_VER}
SRC=$(readlink -f $(dirname $(readlink -f $0))/../..)
DOWNLOADS=${PWD}/downloads

mkdir -p ${BASENAME}
cd ${BASENAME}

# Turn on SWR
if [ $SWR -eq 1 ]
then
  EXTRA_OPTS="${EXTRA_OPTS} -DMESA_SWR_ENABLED=ON"
else
  EXTRA_OPTS="${EXTRA_OPTS} -DMESA_SWR_ENABLED=OFF"
fi

# Set the requested OSPray backend
EXTRA_OPTS="${EXTRA_OPTS} -DOSPRAY_BUILD_ISA=${OSPRAY}"

# Place newer binutils in the path for AVX2 code generation
export PATH=/opt/rh/devtoolset-3/root/usr/bin:${PATH}

if [ "${COMP}" == "intel" ]
then
  # Enable proper C++11/14 with a newer GCC (4.9)
  # Intel >= 16.0.3 already does this in the module file
  # Intel < 16.0.3 *should be able to use newer GCC headers
  # but in reality it breaks with anything 5.x or newer so we
  # use the the GCC from the RedHat SCL devtoolset-3
  if [[ "${COMP_VER}" < "16.0.3" ]]
  then
    export GCC=/opt/rh/devtoolset-3/root/usr/bin
    export LD_LIBRARY_PATH=${GCC}/lib64:${LD_LIBRARY_PATH}
  fi

  # Intel MPI has compier wrappers for both GCC and Intel so make sure we
  # pick the right one
  if [ "${MPI}" == "impi" ]
  then
    export MPICC=mpiicc MPICXX=mpiicpc MPIFC=mpiifort
    MPI_C_ARGS="-DMPI_C_COMPILER:FILEPATH=$(which mpiicc)"
    MPI_CXX_ARGS="-DMPI_CXX_COMPILER:FILEPATH=$(which mpiicpc)"
    MPI_F_ARGS="-DMPI_Fortran_COMPILER:FILEPATH=$(which mpiifort)"
    EXTRA_OPTS="${EXTRA_OPTS} ${MPI_C_ARGS} ${MPI_CXX_ARGS} ${MPI_F_ARGS}"
  fi
fi

echo ${BASENAME} > log.configure
cmake \
  -DPARAVIEWSDK_PACKAGE_FILE_NAME=${BASENAME} \
  -C${SRC}/cmake/sites/LANL-TOSS2-Shared.cmake \
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
