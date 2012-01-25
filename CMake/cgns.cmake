add_external_project(
  cgns
  DEPENDS zlib hdf5
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --enable-shared=all
                    --with-hdf5=<INSTALL_DIR>
                    --with-szip=<INSTALL_DIR>/lib/libsz.so
                    --with-zlib
                    --with-fortran=no
                    --enable-64bit
  BUILD_IN_SOURCE 1
)
