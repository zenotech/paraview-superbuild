## Builds DIY library
## https://svn.mcs.anl.gov/repos/diy/trunk

if(USE_SYSTEM_mpi)
  set(mpicc "${MPI_C_COMPILER}")
  set(mpicxx "${MPI_CXX_COMPILER}")
else ()
  set(mpicc "<INSTALL_DIR>/bin/mpicc")
  set(mpicxx "<INSTALL_DIR>/bin/mpicxx")
endif()

add_external_project(diy
  DEPENDS mpi hdf5
  BUILD_IN_SOURCE 1
  PROCESS_ENVIRONMENT
    MPICC "${mpicc}"
    MPICXX "${mpicxx}"
  CONFIGURE_COMMAND
      <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --enable-fpic --disable-openmp
  BUILD_COMMAND "${CMAKE_COMMAND}" -Ddiy_source=<SOURCE_DIR> -P "${CMAKE_CURRENT_LIST_DIR}/diy.build.cmake"
  INSTALL_COMMAND make install
  )

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
