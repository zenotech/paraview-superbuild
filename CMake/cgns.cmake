
ExternalProject_Add(
  cgns
  PREFIX cgns
  DEPENDS zlib hdf5
  URL "http://paraview.org/files/misc/cgnslib_2.5-5.tar.gz"
  URL_MD5 ae2a2e79b99d41c63e5ed5f661f70fd9
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/downloads
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=${internal_install_root}
                    --enable-shared=all
                    --with-hdf5=${internal_install_root}
                    --with-szip=${internal_install_root}/lib/libsz.so
                    --with-zlib
                    --with-fortran=no
                    --enable-64bit
  BUILD_IN_SOURCE 1
)
