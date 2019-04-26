set(boxlib_mpi_flag 0)
if (mpi_enabled)
  set(boxlib_mpi_flag 1)
endif ()

superbuild_add_project(boxlib
  DEPENDS fortran
  DEPENDS_OPTIONAL mpi
  CMAKE_ARGS
    -DBL_SPACEDIM:STRING=3
    -DBL_USE_PARTICLES:STRING=1
    -DENABLE_POSITION_INDEPENDENT_CODE:BOOL=TRUE
    -DENABLE_MPI:BOOL=${boxlib_mpi_flag})
