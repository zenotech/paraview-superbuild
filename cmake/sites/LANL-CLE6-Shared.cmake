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
set(ENABLE_mpi         ON CACHE BOOL "")
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
set(USE_SYSTEM_bzip2      ON CACHE BOOL "")
set(USE_SYSTEM_boost      ON CACHE BOOL "")
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
set(embree_BUILD_ISA "AVX;AVX2;AVX512KNL" CACHE STRING "")
set(ospray_BUILD_ISA ALL CACHE STRING "")

# ParaView details
set(SUPERBUILD_PROJECT_PARALLELISM 10 CACHE STRING "")
set(paraview_SOURCE_SELECTION 5.4.0 CACHE BOOL "")

# Specify where the necessary tarballs have been downloaded to
set(superbuild_download_location ${CMAKE_BINARY_DIR}/../../downloads CACHE STRING "")

set(ANACONDA_BASE /usr/projects/hpcsoft/cle6.0/common/anaconda/4.1.1-python-2.7)

set(PYTHON_EXECUTABLE                ${ANACONDA_BASE}/bin/python2         CACHE FILEPATH "")
set(PYTHON_INCLUDE_DIR               ${ANACONDA_BASE}/include/python2.7   CACHE PATH     "")
set(PYTHON_LIBRARY                   ${ANACONDA_BASE}/lib/libpython2.7.so CACHE FILEPATH "")

set(FREETYPE_INCLUDE_DIR_freetype2   ${ANACONDA_BASE}/include/freetype2   CACHE PATH     "")
set(FREETYPE_INCLUDE_DIR_ft2build    ${ANACONDA_BASE}/include             CACHE PATH     "")
set(FREETYPE_LIBRARY                 ${ANACONDA_BASE}/lib/libfreetype.so  CACHE FILEPATH "")

set(LIBXML2_INCLUDE_DIR              ${ANACONDA_BASE}/include/libxml2     CACHE PATH     "")
set(LIBXML2_LIBRARIES                ${ANACONDA_BASE}/lib/libxml2.so      CACHE FILEPATH "")
set(LIBXML2_XMLLINT_EXECUTABLE       ${ANACONDA_BASE}/bin/xmllint         CACHE FILEPATH "")

set(PNG_LIBRARY_RELEASE              ${ANACONDA_BASE}/lib/libpng.so       CACHE FILEPATH "")
set(PNG_PNG_INCLUDE_DIR              ${ANACONDA_BASE}/include             CACHE PATH     "")

set(ZLIB_INCLUDE_DIR                 ${ANACONDA_BASE}/include             CACHE PATH     "")
set(ZLIB_LIBRARY_RELEASE             ${ANACONDA_BASE}/lib/libz.so         CACHE FILEPATH "")
