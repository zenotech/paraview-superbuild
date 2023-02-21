set(pdal_platform_dependencies)
if (UNIX)
  list(APPEND pdal_platform_dependencies
    libxml2)
endif ()

superbuild_add_project(pdal
  DEPENDS
    gdal geotiff curl
  DEPENDS_OPTIONAL
    zlib zstd xerces ${pdal_platform_dependencies}
  LICENSE_FILES
    LICENSE.txt
  CMAKE_ARGS
    -DWITH_TESTS:BOOL=OFF
    -DWITH_LZMA:BOOL=OFF
    -DWITH_ZLIB:BOOL=${zlib_enabled}
    -DWITH_ZSTD:BOOL=${zstd_enabled}
    -DBUILD_PLUGIN_HDF:BOOL=OFF
    -DBUILD_PLUGIN_E57:BOOL=${xerces_enabled}
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib)

superbuild_apply_patch(pdal fix-target-curl
  "Fix link pdal with curl")
