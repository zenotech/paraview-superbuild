superbuild_add_project(openvr
  LICENSE_FILES
    LICENSE
  CMAKE_ARGS
    -DBUILD_SHARED:BOOL=TRUE
  INSTALL_COMMAND
  "${CMAKE_COMMAND}"
    -Dsource_location:PATH=<SOURCE_DIR>
    -Dinstall_location:PATH=<INSTALL_DIR>
    -P ${CMAKE_CURRENT_LIST_DIR}/scripts/openvr.install.cmake
  INSTALL_DEPENDS
    ${CMAKE_CURRENT_LIST_DIR}/scripts/openvr.install.cmake
  )
