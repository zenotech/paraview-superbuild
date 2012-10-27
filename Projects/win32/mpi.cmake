add_external_project_or_use_system(mpi

  # OpenMPI has a broken set_target_properties(...) call.
  PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different
                "${SuperBuild_PROJECTS_DIR}/patches/mpi.ompi.CMakeLists.txt"
                "<SOURCE_DIR>/ompi/CMakeLists.txt"

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DOMPI_ENABLE_MPI_PROFILING:BOOL=OFF
    -DCMAKE_BUILD_TYPE:STRING=Release
    -DOMPI_RELEASE_BUILD:BOOL=ON
)

if (NOT USE_SYSTEM_mpi)
  add_extra_cmake_args(
    -DMPIEXEC:FILEPATH=${install_location}/bin/mpiexec.exe
    -DMPI_C_COMPILER:FILEPATH=${install_location}/bin/mpicc.exe
    -DMPI_CXX_COMPILER:FILEPATH=${install_location}/bin/mpicxx.exe
    -DMPI_C_INCLUDE_PATH:STRING=${install_location}/include
    -DMPI_C_LIBRARIES:STRING=${install_location}/lib/libmpi.lib+${install_location}/lib/libopen-rte.lib+${install_location}/lib/libopen-pal.lib+advapi32.lib+Ws2_32.lib+shlwapi.lib
    -DMPI_CXX_INCLUDE_PATH:STRING=${install_location}/include
    -DMPI_CXX_LIBRARIES:STRING=${install_location}/lib/libmpi_cxx.lib
    )

  append_flags(CMAKE_C_FLAGS "/DOMPI_IMPORTS /DOPAL_IMPORTS /DORTE_IMPORTS")
  append_flags(CMAKE_CXX_FLAGS "/DOMPI_IMPORTS /DOPAL_IMPORTS /DORTE_IMPORTS")
endif()
