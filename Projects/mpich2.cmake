# we support using system mpi.
#dependent_option(USE_SYSTEM_MPI
#  "Turn ON to use installed MPI intead of building from source." OFF
#  "ENABLE_MPICH2" OFF)

#if (USE_SYSTEM_MPI)
#  find_package(MPI)
#  # Important variables are (where lang == C|CXX)
#  # MPI_<lang>_FOUND
#  # MPI_<lang>_COMPILER
#  # MPI_<lang>_COMPILE_FLAGS
#  # MPI_<lang>_INCLUDE_PATH
#  # MPI_<lang>_LINK_FLAGS
#  # MPI_<lang>_LIBRARIES
#  # MPIEXEC
#  # MPIEXEC_NUMPROC_FLAG
#  # MPIEXEC_PREFLAGS
#  # MPIEXEC_POSTFLAGS
#
#  # this must be called since we're not using add_external_project().
#  add_system_project(mpich2)
#else ()
add_external_project_or_use_system(mpich2
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
