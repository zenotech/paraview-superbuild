ExternalProject_Add(
  libxml2
  PREFIX libxml2
  URL "ftp://xmlsoft.org/libxml2/libxml2-2.7.8.tar.gz"
  URL_MD5 8127a65e8c3b08856093099b52599c86
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/downloads
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=${internal_install_root}
                    --enable-shared
                    --enable-static=no
                    LDFLAGS=${ldflags}
                    CPPFLAGS=${cppflags}
                    CFLAGS=${cppflags}
  BUILD_IN_SOURCE 1
)
