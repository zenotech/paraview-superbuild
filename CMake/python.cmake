ExternalProject_Add(
  python
  DEPENDS zlib png
  PREFIX python
  URL "http://python.org/ftp/python/2.7.2/Python-2.7.2.tgz"
  URL_MD5 "0ddfe265f1b3d0a8c2459f5bf66894c7"
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/downloads
  CONFIGURE_COMMAND <SOURCE_DIR>/configure 
                    --prefix=${internal_install_root}
                    --enable-unicode
                    --enable-shared
                    LDFLAGS=${ldflags}
                    CPPFLAGS=${cppflags}
                    CFLAGS=${cppflags}
  )

