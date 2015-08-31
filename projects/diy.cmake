## Builds DIY library
## https://svn.mcs.anl.gov/repos/diy/trunk

if (USE_SYSTEM_mpi)
  set(mpicc "${MPI_C_COMPILER}")
  set(mpicxx "${MPI_CXX_COMPILER}")
else ()
  set(mpicc "<INSTALL_DIR>/bin/mpicc")
  set(mpicxx "<INSTALL_DIR>/bin/mpicxx")
endif ()

superbuild_add_project(diy
  DEPENDS mpi hdf5
  BUILD_IN_SOURCE 1
  PROCESS_ENVIRONMENT
    MPICC "${mpicc}"
    MPICXX "${mpicxx}"
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --enable-fpic
      --disable-openmp
  BUILD_COMMAND
    "${CMAKE_COMMAND}"
      -Ddiy_source=<SOURCE_DIR>
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/diy.build.cmake"
  INSTALL_COMMAND
    make install)
