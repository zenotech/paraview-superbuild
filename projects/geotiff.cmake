superbuild_add_project(geotiff
  DEPENDS tiff zlib proj
  LICENSE_FILES
    LICENSE
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DWITH_TIFF:BOOL=${tiff_enabled}
    -DWITH_ZLIB:BOOL=${zlib_enabled}
    -DWITH_UTILITIES:BOOL=OFF)

# GeoTIFF doesn't handle tiff's generated CMake package configuration well.
# https://github.com/OSGeo/libgeotiff/issues/20
superbuild_apply_patch(geotiff tiff-imported-targets
  "Handle TIFF imported targets")
