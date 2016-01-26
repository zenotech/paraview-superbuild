#!/bin/bash

# This is used to build ParaView on Gadget / Trinity

# Validate arguments
if [ $# -ne 3 ]
then
  echo "$(basename $0) compiler compver install_dir"
  exit 1
fi

COMP=$1
case $COMP in
  intel) COMPMOD=intel
    ;;
  gnu) COMPMOD=gcc
    ;;
esac
COMPVER=$2
INST_DIR=$3

. /opt/modules/default/init/bash

# Start with a pristine environment
module purge 1>/dev/null 2>&1

# Load the compilers
module load modules
module load craype
module load PrgEnv-${COMP}
module swap ${COMPMOD} ${COMPMOD}/${COMPVER}
module load craype-haswell
export CRAYPE_LINK_TYPE=dynamic

# Make sure the compiler vars contain the full path to the cray wrappers
export CC=$(which cc)
export CXX=$(which CC)
export FC=$(which ftn)

# Load the Cray-provided libraries
module load cray-mpich
module load cray-hdf5

# Used by the CMake FindHDF5.cmake module
export HDF5_ROOT=${HDF5_DIR}

# Run the build steps
SOURCE_DIR=${HOME}/Code/ParaView/Superbuild/source
BUILD_DIR=/tmp/scratch/pv-build
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# Configure
osmesa_base=/scratch1/users/paraview/haswell/openswr-mesa-11.2.20162201git
$HOME/Code/CMake/build/master/bin/cmake \
  -C${SOURCE_DIR}/CMake/Sites/Cray-CLE6-Shared.cmake \
  -DCMAKE_INSTALL_PREFIX=${INST_DIR} \
  -DUSE_SYSTEM_osmesa:BOOL=ON \
  -DPARAVIEW_RENDERING_BACKEND:STRING=OpenGL2 \
  -DOSMESA_INCLUDE_DIR:PATH=${osmesa_base}/include \
  -DOSMESA_LIBRARY:FILEPATH=${osmesa_base}/lib/libOSMesa.so \
  ${SOURCE_DIR}

# Make
make install
