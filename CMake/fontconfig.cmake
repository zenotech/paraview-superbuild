add_external_project(
  fontconfig
  DEPENDS freetype libxml2
  URL "http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.8.0.tar.gz"
  URL_MD5 77e15a92006ddc2adbb06f840d591c0e
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --disable-docs
                    --enable-libxml2
                    --enable-static=no
  PROCESS_ENVIRONMENT
                    LIBXML2_CFLAGS -I<INSTALL_DIR>/include/libxml2
                    LIBXML2_LIBS -lxml2
)
