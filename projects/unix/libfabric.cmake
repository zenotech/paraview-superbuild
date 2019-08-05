if(BUILD_SHARED_LIBS)
  set(libfabric_args_shared --enable-shared --disable-static)
else()
  set(libfabric_args_shared --disable-shared --enable-static)
endif()

superbuild_add_project(libfabric
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
    --prefix=<INSTALL_DIR>
    ${libfabric_args_shared}
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install
  BUILD_IN_SOURCE 1)
