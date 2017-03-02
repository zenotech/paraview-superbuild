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
set(ENABLE_bzip2       ON CACHE BOOL "")
set(ENABLE_ffmpeg      ON CACHE BOOL "")
set(ENABLE_freetype    ON CACHE BOOL "")
set(ENABLE_genericio   ON CACHE BOOL "")
set(ENABLE_hdf5        ON CACHE BOOL "")
set(ENABLE_libxml2     ON CACHE BOOL "")
set(ENABLE_llvm        ON CACHE BOOL "")
set(ENABLE_matplotlib  ON CACHE BOOL "")
set(ENABLE_mpi         ON  CACHE BOOL "")
set(ENABLE_numpy       ON  CACHE BOOL "")
set(ENABLE_osmesa      ON  CACHE BOOL "")
set(ENABLE_ospray      OFF CACHE BOOL "")
set(ENABLE_paraview    ON  CACHE BOOL "")
set(ENABLE_paraviewsdk ON  CACHE BOOL "")
set(ENABLE_png         ON  CACHE BOOL "")
set(ENABLE_python      ON  CACHE BOOL "")
set(ENABLE_silo        ON  CACHE BOOL "")
set(ENABLE_visitbridge ON  CACHE BOOL "")
set(ENABLE_zlib        ON  CACHE BOOL "")

# These will get pulled from the compute node's userland
set(USE_SYSTEM_bzip2      ON CACHE BOOL "")
set(USE_SYSTEM_freetype   ON CACHE BOOL "")
set(USE_SYSTEM_hdf5       ON CACHE BOOL "")
set(USE_SYSTEM_libxml2    ON CACHE BOOL "")
set(USE_SYSTEM_matplotlib ON CACHE BOOL "")
set(USE_SYSTEM_mpi        ON CACHE BOOL "")
set(USE_SYSTEM_numpy      ON CACHE BOOL "")
set(USE_SYSTEM_png        ON CACHE BOOL "")
set(USE_SYSTEM_python     ON CACHE BOOL "")
set(USE_SYSTEM_zlib       ON CACHE BOOL "")

# Enable all architectures for OSPray
set(ospray_BUILD_ISA ALL CACHE STRING "")

# Paraview details
set(paraview_SOURCE_SELECTION 5.2.0 CACHE BOOL "")
