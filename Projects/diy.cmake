## Builds DIY library
## https://svn.mcs.anl.gov/repos/diy/trunk
if(USE_SYSTEM_mpi)
  add_external_project(diy
    DEPENDS mpi hdf5
    BUILD_IN_SOURCE 1
    PROCESS_ENVIRONMENT
      MPICC "${MPI_C_COMPILER}"
      MPICXX "${MPI_CXX_COMPILER}"
    CONFIGURE_COMMAND
        <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --enable-fpic --disable-openmp
    BUILD_COMMAND make
    INSTALL_COMMAND make install
    )
else()
  add_external_project(diy
    DEPENDS mpi hdf5
    BUILD_IN_SOURCE 1
    PROCESS_ENVIRONMENT
      MPICC "<INSTALL_DIR>/bin/mpicc"
      MPICXX "<INSTALL_DIR>/bin/mpicxx"
    CONFIGURE_COMMAND
        <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --enable-fpic --disable-openmp
    BUILD_COMMAND make
    INSTALL_COMMAND make install
    )
endif()

