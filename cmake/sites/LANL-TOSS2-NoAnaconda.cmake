# Tarballs needing to be downloaded:
# boost
# ffmpeg
# matplotlib
# numpy
# osmesa
# paraview
# python
# visitbridge

# General build settings
set(CMAKE_BUILD_TYPE   Release CACHE STRING "")
set(BUILD_SHARED_LIBS  ON CACHE BOOL "")

# Enable the appropriate packages
set(ENABLE_boost       ON CACHE BOOL "")
set(ENABLE_ffmpeg      ON CACHE BOOL "")
set(ENABLE_freetype    ON CACHE BOOL "")
set(ENABLE_genericio   ON CACHE BOOL "")
set(ENABLE_hdf5        ON CACHE BOOL "")
set(ENABLE_libxml2     ON CACHE BOOL "")
set(ENABLE_llvm        ON CACHE BOOL "")
set(ENABLE_matplotlib  ON CACHE BOOL "")
set(ENABLE_numpy       ON CACHE BOOL "")
set(ENABLE_osmesa      ON CACHE BOOL "")
set(ENABLE_ospray      ON CACHE BOOL "")
set(ENABLE_paraview    ON CACHE BOOL "")
set(ENABLE_paraviewsdk ON CACHE BOOL "")
set(ENABLE_png         ON CACHE BOOL "")
set(ENABLE_python      ON CACHE BOOL "")
set(ENABLE_silo        ON CACHE BOOL "")
set(ENABLE_visitbridge ON CACHE BOOL "")
set(ENABLE_zlib        ON CACHE BOOL "")

# These will get pulled from the compute node's userland
set(USE_SYSTEM_freetype   ON CACHE BOOL "")
set(USE_SYSTEM_hdf5       ON CACHE BOOL "")
set(USE_SYSTEM_libxml2    ON CACHE BOOL "")
#set(USE_SYSTEM_matplotlib ON CACHE BOOL "")
#set(USE_SYSTEM_numpy      ON CACHE BOOL "")
set(USE_SYSTEM_png        ON CACHE BOOL "")
#set(USE_SYSTEM_python     ON CACHE BOOL "")
set(USE_SYSTEM_zlib       ON CACHE BOOL "")

# Specific MPI options for dealing with Intel compiler and Intel MPI
if(NOT "$ENV{LMPI}" STREQUAL "")
  set(ENABLE_mpi     ON CACHE BOOL "")
  set(USE_SYSTEM_mpi ON CACHE BOOL "")
  if("$ENV{LCOMPILER}" STREQUAL "intel" AND
     "$ENV{LMPI}"      STREQUAL "intel-mpi")
    find_program(MPI_C_COMPILER       mpiicc)
    find_program(MPI_CXX_COMPILER     mpiicpc)
    find_program(MPI_Fortran_COMPILER mpiifort)
  endif()
endif()

# Enable all architectures for OSPray
set(ospray_BUILD_ISA ALL CACHE STRING "")

# Paraview details
set(paraview_SOURCE_SELECTION 5.2.0 CACHE BOOL "")
