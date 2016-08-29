# This is a cache file used for build configurations on
# the DoD SGI machines Topaz, Thunder, and Spirit

# General build settings
set(CMAKE_BUILD_TYPE   Release CACHE STRING "")
set(BUILD_SHARED_LIBS  ON CACHE BOOL "")

# Enable the appropriate packages
set(ENABLE_adios       ON CACHE BOOL "")
set(ENABLE_boost       ON CACHE BOOL "")
set(ENABLE_bzip2       ON CACHE BOOL "")
set(ENABLE_ffmpeg      ON CACHE BOOL "")
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
set(USE_SYSTEM_bzip2       ON CACHE BOOL "")
set(USE_SYSTEM_freetype    ON CACHE BOOL "")
set(USE_SYSTEM_hdf5        ON CACHE BOOL "")
set(USE_SYSTEM_lapack      ON CACHE BOOL "")
set(USE_SYSTEM_libxml2     ON CACHE BOOL "")
set(USE_SYSTEM_mpi         ON CACHE BOOL "")
set(USE_SYSTEM_zlib        ON CACHE BOOL "")

# Enable all architectures for OSPray
set(OSPRAY_BUILD_ISA ALL CACHE STRING "")

# Paraview details
set(paraview_FROM_GIT      OFF CACHE BOOL "")

# Freezing when building our own python seems to generate broken
# pv* executables
#set(PARAVIEW_FREEZE_PYTHON ON  CACHE BOOL "")
