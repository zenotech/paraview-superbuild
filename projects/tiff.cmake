superbuild_add_project(tiff
  DEPENDS
    zlib
  DEPENDS_OPTIONAL
    libjpegturbo
  LICENSE_FILES
    LICENSE.md
  CMAKE_ARGS
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DCMAKE_INSTALL_NAME_DIR:STRING=<INSTALL_DIR>/lib
    -Dtiff-docs:BOOL=OFF
    -Dcxx:BOOL=OFF
    -Djbig:BOOL=OFF
    -Djpeg:BOOL=${libjpegturbo_enabled}
    -Dlerc:BOOL=OFF
    -Dlibdeflat:BOOL=OFF
    -Dlzma:BOOL=OFF
    -Dwebp:BOOL=OFF
    -Dzstd:BOOL=OFF
    -Dzlib:BOOL=${zlib_enabled}
    )
