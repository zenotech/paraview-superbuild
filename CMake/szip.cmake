add_external_project(
  szip
  URL "http://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz"
  URL_MD5 902f831bcefb69c6b635374424acbead
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --enable-encoding
                    --prefix=<INSTALL_DIR>
)
