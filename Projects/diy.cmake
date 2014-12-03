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

# Required because OS X's standard library now has a globally-accessible 'rank'
# symbol (std::__1::rank) which conflicts with the static-global 'rank' in
# diy.cpp.
add_external_project_step(patch_diy_src
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          "${SuperBuild_PROJECTS_DIR}/patches/diy.src.diy.cpp"
          "<SOURCE_DIR>/src/diy.cpp"
DEPENDEES update # do after update
DEPENDERS patch  # do before patch
)
