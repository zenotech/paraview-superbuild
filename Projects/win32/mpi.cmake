
add_external_project_or_use_system(mpi
  CONFIGURE_COMMAND ${CMAKE_COMMAND} 
                    -G "NMake Makefiles"
                    -DCMAKE_INSTALL_PREFIX:PATH=${install_location}
                    -DBUILD_SHARED_LIBS:BOOL=ON
                    -DCMAKE_BUILD_TYPE:STRING=Release
                    <SOURCE_DIR>
  BUILD_COMMAND ${NMAKE_PATH}
  INSTALL_COMMAND ${NMAKE_PATH} install
)
