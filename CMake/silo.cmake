
ExternalProject_Add(
  silo
  PREFIX silo
  DEPENDS zlib hdf5
  URL "http://paraview.org/files/misc/silo-4.8-bsd.tar.gz"
  URL_MD5 03e27c977f34dc6e9a5f3864153c24fe
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/downloads
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=${internal_install_root}
                    --enable-shared=yes
                    --enable-static=no
                    --enable-fortran=no
                    --enable-browser=no
                    --enable-silex=no
                    --with-szlib=${internal_install_root}
                    --with-hdf5=${internal_install_root}/include,${internal_install_root}/lib
                    LDFLAGS=${ldflags}
                    CPPFLAGS=${cppflags}
                    CFLAGS=${cppflags}
)
