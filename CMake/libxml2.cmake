add_external_project(
  libxml2
  URL "ftp://xmlsoft.org/libxml2/libxml2-2.7.8.tar.gz"
  URL_MD5 8127a65e8c3b08856093099b52599c86
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --enable-shared
                    --enable-static=no
  BUILD_IN_SOURCE 1
)
