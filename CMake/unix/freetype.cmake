add_external_project(
  freetype
  DEPENDS zlib
  URL http://download.savannah.gnu.org/releases/freetype/freetype-2.4.8.tar.gz
  URL_MD5 5d82aaa9a4abc0ebbd592783208d9c76
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --enable-static=no
                     --with-sysroot=<INSTALL_DIR>
) 
