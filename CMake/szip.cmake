ExternalProject_Add(
  szip
  PREFIX szip
  URL "http://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz"
  URL_MD5 902f831bcefb69c6b635374424acbead
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/downloads
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --enable-encoding
                    --prefix=${internal_install_root}
                    LDFLAGS=${ldflags}
                    CPPFLAGS=${cppflags}
                    CFLAGS=${cppflags}
)
