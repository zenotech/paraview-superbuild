add_external_project(
  python
  DEPENDS zlib png
  CONFIGURE_COMMAND <SOURCE_DIR>/configure 
                    --prefix=<INSTALL_DIR>
                    --enable-unicode
                    --enable-shared
  )
