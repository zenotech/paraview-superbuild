add_external_dummy_project(mpi)

if (mpi_ENABLED)
  find_package(MPI REQUIRED)
endif ()
