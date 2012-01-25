add_external_project(
  mpich2
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --enable-shared
                    --disable-static
                    --disable-f77
                    --disable-fc
  BUILD_IN_SOURCE 1
)
