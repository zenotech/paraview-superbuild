if (BUILD_SHARED_LIBS)
  set(silo_shared_args --enable-shared --disable-static)
else ()
  set(silo_shared_args --disable-shared --enable-static)
endif ()

superbuild_add_project(silo
  DEPENDS zlib hdf5
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      ${silo_shared_args}
      --enable-fortran=no
      --enable-browser=no
      --enable-silex=no
      --with-szlib=<INSTALL_DIR>
      --with-hdf5=<INSTALL_DIR>/include,<INSTALL_DIR>/lib)
