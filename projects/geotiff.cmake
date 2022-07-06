superbuild_add_project(geotiff
  DEPENDS tiff zlib proj
  LICENSE_FILES
    LICENSE
  CMAKE_ARGS
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DWITH_TIFF:BOOL=${tiff_enabled}
    -DWITH_ZLIB:BOOL=${zlib_enabled}
    -DWITH_UTILITIES:BOOL=OFF)
