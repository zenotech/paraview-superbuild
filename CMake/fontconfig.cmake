ExternalProject_Add(
  fontconfig
  PREFIX fontconfig
  DEPENDS freetype
  URL "http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.8.0.tar.gz"
  URL_MD5 77e15a92006ddc2adbb06f840d591c0e
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/downloads
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=${internal_install_root}
                    --disable-docs
                    --enable-libxml2
                    --enable-static=no
                    LDFLAGS=${ldflags}
                    CPPFLAGS=${cppflags}
                    CFLAGS=${cppflags}

)
