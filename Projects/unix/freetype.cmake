add_external_project_or_use_system(
  freetype
  DEPENDS zlib
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --enable-static=no
                     --with-sysroot=<INSTALL_DIR>
) 
