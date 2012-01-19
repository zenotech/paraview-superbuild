
ExternalProject_Add(
  freetype
  PREFIX freetype
  DEPENDS zlib
  URL http://download.savannah.gnu.org/releases/freetype/freetype-2.4.8.tar.gz
  URL_MD5 5d82aaa9a4abc0ebbd592783208d9c76
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/downloads
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=${internal_install_root}
                    --enable-static=no
                     --with-sysroot=${internal_install_root}
                    LDFLAGS=${ldflags}
                    CPPFLAGS=${cppflags}
                    CFLAGS=${cppflags}
) 
  
