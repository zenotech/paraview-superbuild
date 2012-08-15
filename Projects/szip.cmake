add_external_project(szip
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --enable-encoding
                    --prefix=<INSTALL_DIR>
)

# any project depending on szip, inherits these cmake variables
add_extra_cmake_args(
    -DSZIP_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/${CMAKE_SHARED_LIBRARY_PREFIX}sz${CMAKE_SHARED_LIBRARY_SUFFIX}
    -DSZIP_INCLUDE_DIR:FILEPATH=<INSTALL_DIR>/include)
