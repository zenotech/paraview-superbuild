# This is a config file for building ParaView on a Knights Landing
# development platform at Kitware.  The machine runs
# CentOS 7 with compilers and modules from OpebnHPC.  The following
# modules are to be loaded before building:
#
# intel impi boost hdf5 numpy
#
# substitute intel and impi with compiler and MPI modules of choice.

# General build settings
set(CMAKE_BUILD_TYPE   Release CACHE STRING "")
set(BUILD_SHARED_LIBS  ON CACHE BOOL "")

# Enable the appropriate packages
set(ENABLE_boost       ON CACHE BOOL "")
set(ENABLE_ffmpeg      ON CACHE BOOL "")
set(ENABLE_freetype    ON CACHE BOOL "")
set(ENABLE_genericio   ON CACHE BOOL "")
set(ENABLE_hdf5        ON CACHE BOOL "")
# disabling for now since I don't see mesa enabled
# and we're using system MPI.
# set(ENABLE_launchers   ON CACHE BOOL "")
set(ENABLE_libxml2     ON CACHE BOOL "")
set(ENABLE_llvm        ON CACHE BOOL "")
set(ENABLE_matplotlib  ON CACHE BOOL "")
set(ENABLE_numpy       ON CACHE BOOL "")
set(ENABLE_ospray      ON CACHE BOOL "")
set(ENABLE_paraview    ON CACHE BOOL "")
set(ENABLE_png         ON CACHE BOOL "")
set(ENABLE_python      ON CACHE BOOL "")
set(ENABLE_silo        ON CACHE BOOL "")
set(ENABLE_visitbridge ON CACHE BOOL "")
set(ENABLE_zlib        ON CACHE BOOL "")

# These will get pulled from the compute node's userland
set(USE_SYSTEM_boost       ON CACHE BOOL "")
set(USE_SYSTEM_freetype    ON CACHE BOOL "")
set(USE_SYSTEM_hdf5        ON CACHE BOOL "")
set(USE_SYSTEM_libxml2     ON CACHE BOOL "")
set(USE_SYSTEM_matplotlib  ON CACHE BOOL "")
set(USE_SYSTEM_numpy       ON CACHE BOOL "")
set(USE_SYSTEM_png         ON CACHE BOOL "")
set(USE_SYSTEM_python      ON CACHE BOOL "")
set(USE_SYSTEM_zlib        ON CACHE BOOL "")

# Specific MPI options for dealing with Intel compiler and Intel MPI
if(NOT "$ENV{LMOD_FAMILY_MPI}" STREQUAL "")
  set(ENABLE_mpi     ON CACHE BOOL "")
  set(USE_SYSTEM_mpi ON CACHE BOOL "")
  if("$ENV{LMOD_FAMILY_COMPILER}" STREQUAL "intel" AND
     "$ENV{LMOD_FAMILY_MPI}"      STREQUAL "impi")
    find_program(MPI_C_COMPILER       mpiicc)
    find_program(MPI_CXX_COMPILER     mpiicpc)
    find_program(MPI_Fortran_COMPILER mpiifort)
  endif()
endif()

# Enable AVX512 for OSPray when using Intel
if("$ENV{LMOD_FAMILY_COMPILER}" STREQUAL "intel")
  set(ospray_BUILD_ISA AVX512 CACHE STRING "")
else()
  set(ospray_BUILD_ISA AVX2 CACHE STRING "")
endif()

# Use newer Mesa since it's *way* faster on KNL
set(mesa_SOURCE_SELECTION "v13.0.0-rc2" CACHE STRING "")
set(mesa_USE_SWR ON CACHE BOOL "")

# Too many CPU cores on KNL.  Limit build threads to 32
set(SUPERBUILD_PROJECT_PARALLELISM 32 CACHE STRING "")
