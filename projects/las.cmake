set(las_configure_flags)
if (UNIX AND NOT APPLE)
  list(APPEND las_configure_flags
    -DCMAKE_INSTALL_RPATH:STRING=<INSTALL_DIR>/lib)
endif ()

superbuild_add_project(las
  LICENSE_FILES
    LICENSE.txt
  SPDX_LICENSE_IDENTIFIER
    "BSD-3-Clause AND MIT AND BSL-1.0"
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2007, Martin Isenburg"
    "Copyright (c) 2008, Howard Butler"
    "Copyright (c) 2008, Mateusz Loskot"
    "Copyright (c) 2008, Phil Vachon"
    "Copyright (c) 2008, Frank Warmerdam"
    "Copyright (c) 2008, Martin Rodriguez"
    "Copyright (c) 2016, Oscar Martinez Rubi"
    "Copyright (c) 2016, Romulo Goncalves"
    "Copyright Mateusz Loskot 2007"
    "Copyright Phil Vachon 2007"
    "Copyright John Maddock 2001"
    "Copyright Jens Mauer 2001"
    "Copyright Beman Dawes 1999"
    "Copyright Mateusz Loskot 2007"
    "Copyright Caleb Epstein 2005"
    "Copyright John Maddock 2006"
    "Copyright (C) 1998 Paul E. Jones"
    "Copyright Nicolai M. Josuttis 1999"
    "Copyright Mateusz Loskot 2008"
    "Copyright (c) 2007, Sean C. Gillies"
    "Copyright (c) 2005, Frank Warmerdam"
    "Copyright (c) 1999, Frank Warmerdam"
    "copyright (c) 2012, Luca Delucchi, Fondazione Edmund Mach"
    "Copyright (c) 2016, Oscar Martinez Rubi"
    "Copyright (c) 2016, Romulo Goncalves"
  DEPENDS boost
  CMAKE_ARGS
    -DWITH_GDAL:BOOL=FALSE
    -DBUILD_OSGEO4W:BOOL=OFF
    -DWITH_GEOTIFF:BOOL=FALSE
    -DWITH_LASZIP:BOOL=FALSE
    -DWITH_TESTS:BOOL=FALSE
    -DWITH_UTILITIES:BOOL=FALSE
    -DBoost_USE_STATIC_LIBS:BOOL=FALSE
    ${las_configure_flags})

# this patch is commited upstream at 4dbc30a7e7e099cbe01a7c192ec19d231cc26894
superbuild_apply_patch(las respect-with-geotiff
  "find_package GeoTIFF only if WITH_GEOTIFF")

superbuild_apply_patch(las enable-outside-boost-options
  "Enable outside boost options")

superbuild_apply_patch(las add-boost-include-dirs
  "Boost include dirs are needed on Windows")

superbuild_apply_patch(las allow-rpath
  "Don't reject RPATH settings on Linux")

superbuild_apply_patch(las new-boost
  "Support newer Boost versions")

if (WIN32)
  superbuild_append_flags(cxx_flags "-DBOOST_ALL_NO_LIB" PROJECT_ONLY)
endif()

if (APPLE)
  superbuild_append_flags(cxx_flags "-stdlib=libc++" PROJECT_ONLY)
  superbuild_append_flags(ld_flags "-stdlib=libc++" PROJECT_ONLY)
endif ()
