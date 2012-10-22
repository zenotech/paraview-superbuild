add_external_project_or_use_system(mpi
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --enable-shared
                    --disable-static
                    --disable-f77
                    --disable-fc
  # PVExternalProject_Add sets up an parallel build, by default.
  # that doesn't work for the version of MPICH2 we're using.
  BUILD_COMMAND ${CMAKE_MAKE_PROGRAM}
  BUILD_IN_SOURCE 1
)
