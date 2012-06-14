add_external_project(
  silo
  DEPENDS zlib hdf5
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --enable-shared=yes
                    --enable-static=no
                    --enable-fortran=no
                    --enable-browser=no
                    --enable-silex=no
                    --with-szlib=<INSTALL_DIR>
                    --with-hdf5=<INSTALL_DIR>/include,<INSTALL_DIR>/lib
)
