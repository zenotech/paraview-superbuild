add_external_project(
  mpich2
  URL http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/1.4.1p1/mpich2-1.4.1p1.tar.gz
  URL_MD5 b470666749bcb4a0449a072a18e2c204
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --enable-shared
                    --disable-static
                    --disable-f77
                    --disable-fc
  BUILD_IN_SOURCE 1
)
