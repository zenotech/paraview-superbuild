if(BUILD_SHARED_LIBS)
  set(shared_args --enable-shared --disable-static)
else()
  set(shared_args --disable-shared --enable-static)
endif()
add_external_project_or_use_system(mpi
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    ${shared_args}
                    --disable-f77
                    --disable-fc
                    --disable-mpe
  # PVExternalProject_Add sets up an parallel build, by default.
  # that doesn't work for the version of MPICH2 we're using.
  BUILD_COMMAND ${CMAKE_MAKE_PROGRAM}
  BUILD_IN_SOURCE 1
)
if(NOT USE_SYSTEM_mpi)
  set(MPI_C_COMPILER <INSTALL_DIR>/bin/mpicc)
  set(MPI_CXX_COMPILER <INSTALL_DIR>/bin/mpic++)
endif()
