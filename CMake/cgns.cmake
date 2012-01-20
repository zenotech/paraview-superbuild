add_external_project(
  cgns
  DEPENDS zlib hdf5
  URL "http://paraview.org/files/misc/cgnslib_2.5-5.tar.gz"
  URL_MD5 ae2a2e79b99d41c63e5ed5f661f70fd9
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
