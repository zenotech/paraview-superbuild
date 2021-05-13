# General build settings
set(CMAKE_BUILD_TYPE   Release CACHE STRING "")
set(BUILD_SHARED_LIBS  ON CACHE BOOL "")

# Enable the appropriate packages
set(ENABLE_boost       ON CACHE BOOL "")
set(ENABLE_bzip2       OFF CACHE BOOL "")
set(ENABLE_cosmotools  ON CACHE BOOL "")
set(ENABLE_ffmpeg      ON CACHE BOOL "")
set(ENABLE_freetype    ON CACHE BOOL "")
set(ENABLE_genericio   ON CACHE BOOL "")
set(ENABLE_hdf5        ON CACHE BOOL "")
set(ENABLE_libxml2     OFF CACHE BOOL "")
set(ENABLE_matplotlib  ON CACHE BOOL "")
set(ENABLE_mpi         ON CACHE BOOL "")
set(ENABLE_numpy       ON CACHE BOOL "")
set(ENABLE_osmesa      ON CACHE BOOL "")
set(ENABLE_ospray      OFF CACHE BOOL "")
set(ENABLE_paraview    ON CACHE BOOL "")
set(ENABLE_paraviewsdk ON CACHE BOOL "")
set(ENABLE_png         OFF CACHE BOOL "")
set(ENABLE_python      ON CACHE BOOL "")
set(ENABLE_silo        ON CACHE BOOL "")
set(ENABLE_visitbridge ON CACHE BOOL "")
set(ENABLE_vtkm        OFF CACHE BOOL "")
set(ENABLE_xdmf3       ON CACHE BOOL "")
set(ENABLE_zlib        ON CACHE BOOL "")

# Work around cmake bug, which values from `which cc,CC,ftn`
set(MPI_CXX_COMPILER /opt/cray/pe/craype/2.5.12/bin/CC CACHE STRING "")
set(MPI_C_COMPILER /opt/cray/pe/craype/2.5.12/bin/cc CACHE STRING "")
set(MPI_Fortran_COMPILER /opt/cray/pe/craype/2.5.12/bin/ftn CACHE STRING "")

# These will get pulled from the compute node's userland
set(USE_SYSTEM_boost      OFF CACHE BOOL "")
set(USE_SYSTEM_bzip2      OFF CACHE BOOL "")
set(USE_SYSTEM_freetype   ON CACHE BOOL "")
set(USE_SYSTEM_hdf5       ON CACHE BOOL "")
set(USE_SYSTEM_libxml2    ON CACHE BOOL "")
set(USE_SYSTEM_matplotlib ON CACHE BOOL "")
set(USE_SYSTEM_mpi        ON CACHE BOOL "")
set(USE_SYSTEM_numpy      ON CACHE BOOL "")
set(USE_SYSTEM_osmesa     OFF CACHE BOOL "")
set(USE_SYSTEM_png        ON CACHE BOOL "")
set(USE_SYSTEM_python     ON CACHE BOOL "")
set(USE_SYSTEM_zlib       ON CACHE BOOL "")

# ParaView details
set(SUPERBUILD_PROJECT_PARALLELISM 32 CACHE STRING "")
set(paraview_SOURCE_SELECTION 5.4.0 CACHE STRING "")

# Specify where the necessary tarballs have been downloaded to
set(superbuild_download_location ${CMAKE_BINARY_DIR}/../../downloads CACHE STRING "")

# Another, ensure we get cray python
set(PYTHON_EXECUTABLE /opt/python/17.06.1/bin/python2.7 CACHE FILEPATH "")
set(PYTHON_INCLUDE_DIR /opt/python/17.06.1/include/python2.7 CACHE PATH "")
set(PYTHON_LIBRARY /opt/python/17.06.1/lib/libpython2.7.so CACHE FILEPATH "")
