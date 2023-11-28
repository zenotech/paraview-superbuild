set(gdal_optional_depends)
if (ALLOW_openssl)
  list(APPEND gdal_optional_depends
    openssl)
endif ()

set(gdal_use_iconv OFF)
set(gdal_configure_flags)
if (UNIX AND NOT APPLE)
  set(gdal_use_iconv ON)
  list(APPEND gdal_configure_flags
    -DCMAKE_INSTALL_RPATH:STRING=<INSTALL_DIR>/lib)
endif ()

superbuild_add_project(gdal
  DEPENDS cxx11 zlib proj tiff geotiff png jsonc
  DEPENDS_OPTIONAL blosc libjpegturbo hdf5 sqlite
    ${gdal_optional_depends}

    # If enabled, MPI flags need passed to satisfy HDF5 includes on Windows.
    mpi

    # Add as a dependency but disabled below; gdal searches before checking if
    # it is disabled, so a race exists is these projects are partially
    # installed while configuring gdal.
    netcdf
  LICENSE_FILES
    LICENSE.TXT
  SPDX_LICENSE_IDENTIFIER
    "MIT AND BSD-3-Clause AND Apache-2.0 AND ISC AND Info-ZIP"
  SPDX_COPYRIGHT_TEXT
    "Copyright The GDAL/OGR contributors" # No explicit copyright statement for the project itself: https://github.com/OSGeo/gdal/issues/859
    "Copyright (c) 2002, Industrial Light & Magic, a division of Lucas Digital Ltd. LLC"
    "Copyright (C) 1996 Hughes and Applied Research Corporation"
    "Copyright (c) 1997-2003, Utrecht University"
    "Copyright (c) 1990-2005 Info-ZIP"
    "Copyright (c) 2009, David F. Rogers"
    "Copyright (C) 1993 by Sun Microsystems, Inc."
    "Copyright 2014 PDFium Authors"
    "Copyright (c) 2002-2012, California Institute of Technology"
    "Copyright 2014-2015 Esri"
    "Copyright 2000-2022 Kitware, Inc. and Contributors"
    "Copyright (c) 2018, Bjorn Harrtell"
    "Copyright (c) 2018, Vladimir Agafonkin"
    "Copyright 2021 Google Inc."
  CMAKE_ARGS
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DGDAL_USE_EXTERNAL_LIBS:BOOL=OFF
    -DGDAL_USE_INTERNAL_LIBS:BOOL=OFF
    -DGDAL_USE_BLOSC:BOOL=${blosc_enabled}
    -DGDAL_USE_GEOTIFF:BOOL=${geotiff_enabled}
    -DGDAL_USE_HDF5:BOOL=${hdf5_enabled}
    -DGDAL_USE_ICONV:BOOL=${gdal_use_iconv}
    -DGDAL_USE_JPEG:BOOL=${libjpegturbo_enabled}
    -DGDAL_USE_JSONC:BOOL=${jsonc_enabled}
    -DGDAL_USE_NetCDF:BOOL=OFF
    -DGDAL_USE_OPENSSL:BOOL=${openssl_enabled}
    -DGDAL_USE_PNG:BOOL=${png_enabled}
    -DGDAL_USE_SQLITE3:BOOL=${sqlite_enabled}
    -DGDAL_USE_TIFF:BOOL=${tiff_enabled}
    -DGDAL_USE_ZLIB:BOOL=${zlib_enabled}
    -DGDAL_BUILD_OPTIONAL_DRIVERS:BOOL=OFF
    -DGDAL_ENABLE_DRIVER_HDF5:BOOL=${hdf5_enabled}
    -DOGR_ENABLE_OPTIONAL_DRIVERS:BOOL=OFF
    -DOGR_ENABLE_DRIVER_DGN:BOOL=OFF
    -DOGR_ENABLE_DRIVER_IDRISI:BOOL=OFF
    -DOGR_ENABLE_DRIVER_SDTS:BOOL=OFF
    -DOGR_ENABLE_DRIVER_S57:BOOL=OFF
    -DBUILD_APPS:BOOL=OFF
    -DBUILD_CSHARP_BINDINGS:BOOL=OFF
    -DBUILD_JAVA_BINDINGS:BOOL=OFF
    -DBUILD_PYTHON_BINDINGS:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    ${gdal_configure_flags})

superbuild_apply_patch(gdal parallel-hdf5-windows
  "Link to MPI if HDF5 is parallel")
