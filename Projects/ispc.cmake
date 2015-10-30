add_external_project(ispc
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ispc <INSTALL_DIR>/bin/
  )
