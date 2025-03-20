set(geotiff_options)
if (UNIX AND NOT APPLE)
  list(APPEND geotiff_options
    -DCMAKE_INSTALL_RPATH:STRING=<INSTALL_DIR>/lib)
endif ()

superbuild_add_project(geotiff
  DEPENDS tiff zlib proj
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 1999, Frank Warmerdam"
    "copyright (c) 1995   Niles D. Ritter"
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DWITH_TIFF:BOOL=${tiff_enabled}
    -DWITH_ZLIB:BOOL=${zlib_enabled}
    -DWITH_UTILITIES:BOOL=OFF
    ${geotiff_options})

# GeoTIFF doesn't handle tiff's generated CMake package configuration well.
# https://github.com/OSGeo/libgeotiff/issues/20
superbuild_apply_patch(geotiff tiff-imported-targets
  "Handle TIFF imported targets")
