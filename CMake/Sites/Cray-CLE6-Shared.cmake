# Tarballs needing to be downloaded:
# boost
# matplotlib
# numpy
# osmesa
# paraview
# python
# visitbridge

set(CMAKE_BUILD_TYPE  Release CACHE STRING "")

if("$ENV{CRAYPE_LINK_TYPE}" STREQUAL "dynamic")
  set(BUILD_SHARED_LIBS ON CACHE BOOL "")
  set(LIB_EXT ".so")
else()
  set(BUILD_SHARED_LIBS OFF CACHE BOOL "")
  set(LIB_EXT ".a")
endif()

set(ENABLE_boost       ON CACHE BOOL "")
set(ENABLE_bzip2       ON CACHE BOOL "")
set(ENABLE_freetype    ON CACHE BOOL "")
set(ENABLE_hdf5        ON CACHE BOOL "")
set(ENABLE_libxml2     ON CACHE BOOL "")
set(ENABLE_matplotlib  ON CACHE BOOL "")
set(ENABLE_mpi         ON CACHE BOOL "")
set(ENABLE_numpy       ON CACHE BOOL "")
set(ENABLE_osmesa      ON CACHE BOOL "")
set(ENABLE_paraview    ON CACHE BOOL "")
set(ENABLE_paraviewsdk ON CACHE BOOL "")
set(ENABLE_png         ON CACHE BOOL "")
set(ENABLE_python      ON CACHE BOOL "")
set(ENABLE_visitbridge ON CACHE BOOL "")
set(ENABLE_zlib        ON CACHE BOOL "")

# These will get pulled from the compute node's userland
set(USE_SYSTEM_boost      ON CACHE BOOL "")
set(USE_SYSTEM_bzip2      ON CACHE BOOL "")
set(USE_SYSTEM_freetype   ON CACHE BOOL "")
set(USE_SYSTEM_libxml2    ON CACHE BOOL "")
set(USE_SYSTEM_matplotlib ON CACHE BOOL "")
set(USE_SYSTEM_numpy      ON CACHE BOOL "")
set(USE_SYSTEM_python     ON CACHE BOOL "")
set(USE_SYSTEM_zlib       ON CACHE BOOL "")

# CDIReader plugin is broken when using the Cray HDF5 library with
# VTK's internal netcdf
set(PV_EXTRA_CMAKE_ARGS -DPARAVIEW_BUILD_PLUGIN_CDIReader:BOOL=OFF)

# Set the OSMesa options in the actual build script as thier location will
# be different on every machine
#set(USE_SYSTEM_osmesa     ON CACHE BOOL "")
#set(osmesa_base /scratch1/users/atkins3/openswr/avx2)
#set(OSMESA_INCLUDE_DIR ${osmesa_base}/include          CACHE PATH     "")
#set(OSMESA_LIBRARY     ${osmesa_base}/lib/libOSMesa.so CACHE FILEPATH "")

# This comes form the cray-hdf5 module
set(USE_SYSTEM_hdf5     ON CACHE BOOL "")

# This comes from the cray-mpich module
set(USE_SYSTEM_mpi      ON CACHE BOOL "")
find_program(MPIEXEC aprun)

# Make sure the final ParaView build uses the whole node
set(PV_MAKE_NCPUS 20 CACHE STRING "")

# Download location
set(download_location $ENV{HOME}/Code/ParaView/Superbuild/downloads
  CACHE STRING "")

set(ParaView_FROM_GIT OFF CACHE BOOL "")
