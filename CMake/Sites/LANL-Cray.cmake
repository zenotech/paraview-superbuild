# Tarballs needing to be downloaded:
# boost
# ffmpeg (broken on Cielo)
# matplotlib
# numpy
# osmesa
# paraview
# python
# visitbridge

set(CMAKE_BUILD_TYPE  Release CACHE STRING "")

if("$ENV{CRAYPE_LINK_TYPE}" STREQUAL "dynamic")
  set(BUILD_SHARED_LIBS ON CACHE BOOL "")
  set(LIB_EXT ${CMAKE_SHARED_LIBRARY_SUFFIX})
else()
  set(BUILD_SHARED_LIBS OFF CACHE BOOL "")
  set(LIB_EXT ${CMAKE_STATIC_LIBRARY_SUFFIX})
endif()

set(ENABLE_boost       ON CACHE BOOL "")
set(ENABLE_bzip2       ON CACHE BOOL "")
#set(ENABLE_ffmpeg      ON CACHE BOOL "") Broken on Cielo
set(ENABLE_freetype    ON CACHE BOOL "")
set(ENABLE_hdf5        ON CACHE BOOL "")
set(ENABLE_lapack      ON CACHE BOOL "")
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
set(USE_SYSTEM_bzip2    ON CACHE BOOL "")
set(USE_SYSTEM_freetype ON CACHE BOOL "")
set(USE_SYSTEM_libxml2  ON CACHE BOOL "")
set(USE_SYSTEM_png      ON CACHE BOOL "")
set(USE_SYSTEM_zlib     ON CACHE BOOL "")

# This comes form the cray-hdf5 module
set(USE_SYSTEM_hdf5     ON CACHE BOOL "")

# This comes from the cray-libsci module
string(TOLOWER "$ENV{PE_ENV}" PE_low)
set(USE_SYSTEM_lapack   ON CACHE BOOL "")
set(BLAS_LIBRARIES
  "$ENV{CRAY_LIBSCI_PREFIX_DIR}/lib/libsci_${PE_low}.${LIB_EXT}"
  CACHE FILEPATH "")
set(LAPACK_LIBRARIES
  "$ENV{CRAY_LIBSCI_PREFIX_DIR}/lib/libsci_${PE_low}.${LIB_EXT}"
  CACHE FILEPATH "")

# This comes from the cray-mpich module
set(USE_SYSTEM_mpi      ON CACHE BOOL "")

# Force the internal python version
# not sure why we need to do this but otherwise the wrong python version gets
# found, but only sometimes ???
set(PV_EXTRA_CMAKE_ARGS
  "-DPYTHON_EXECUTABLE:FILEPATH=\${install_location}/bin/python\${ep_list_separator}-DPYTHON_LIBRARY:FILEPATH=\${install_location}/lib/libpython2.7.so\${ep_list_separator}-DPYTHON_INCLUDE_DIR:PATH=\${install_location}/include/python2.7"
  CACHE STRING "")

# Make sure the final ParaView build uses the whole node
include(ProcessorCount)
ProcessorCount(N)
if(NOT N EQUAL 0)
  set(PV_MAKE_NCPUS ${N} CACHE STRING "")
else()
  set(PV_MAKE_NCPUS 5 CACHE STRING "")
endif()

# Download location
set(download_location /usr/projects/packages/hpc_paraview/superbuild/downloads
  CACHE STRING "")

set(ParaView_FROM_GIT OFF CACHE BOOL "")
