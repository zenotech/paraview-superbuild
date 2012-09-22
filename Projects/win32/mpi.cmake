
# it's essential to build ompi static, other we are required to add
# \DOMPI_IMPORTS etc. to the ParaView build flags and that's just annoying.
add_external_project_or_use_system(mpi
  CONFIGURE_COMMAND ${CMAKE_COMMAND} 
                    -G "NMake Makefiles"
                    -DCMAKE_INSTALL_PREFIX:PATH=${install_location}
                    -DBUILD_SHARED_LIBS:BOOL=FALSE
                    -DCMAKE_BUILD_TYPE:STRING=Release
                    -DOMPI_RELEASE_BUILD:BOOL=TRUE
                    <SOURCE_DIR>
  BUILD_COMMAND ${NMAKE_PATH}
  INSTALL_COMMAND ${NMAKE_PATH} install
)

if (NOT USE_SYSTEM_mpi)
  add_extra_cmake_args(
    -DMPIEXEC:FILEPATH=${install_location}/bin/mpiexec.exe
    -DMPI_C_COMPILER:FILEPATH=${install_location}/bin/mpicc.exe
    -DMPI_CXX_COMPILER:FILEPATH=${install_location}/bin/mpicxx.exe
    -DMPI_C_INCLUDE_PATH:STRING=${install_location}/include
    -DMPI_C_LIBRARIES:STRING=${install_location}/lib/libmpi.lib+${install_location}/lib/libopen-rte.lib+${install_location}/lib/libopen-pal.lib+w2_32.lib+Psapi.lib
    -DMPI_CXX_INCLUDE_PATH:STRING=${install_location}/include
    -DMPI_CXX_LIBRARIES:STRING=${install_location}/lib/libmpi_cxx.lib
    )
endif()
