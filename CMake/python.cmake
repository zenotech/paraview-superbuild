add_external_project(
  python
  DEPENDS zlib png
  URL "http://python.org/ftp/python/2.7.2/Python-2.7.2.tgz"
  URL_MD5 "0ddfe265f1b3d0a8c2459f5bf66894c7"
  CONFIGURE_COMMAND <SOURCE_DIR>/configure 
                    --prefix=<INSTALL_DIR>
                    --enable-unicode
                    --enable-shared
  )
