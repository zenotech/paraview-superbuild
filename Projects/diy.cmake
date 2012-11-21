## Builds DIY library
## https://svn.mcs.anl.gov/repos/diy/trunk
add_external_project(diy
    DEPENDS mpi
    BUILD_IN_SOURCE 1
    PROCESS_ENVIRONMENT
      MPICC "<INSTALL_DIR>/bin/mpicc"
      MPICXX "<INSTALL_DIR>/bin/mpicxx"
    CONFIGURE_COMMAND
        <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --enable-fpic --disable-openmp
    BUILD_COMMAND make
    INSTALL_COMMAND make install
        )

