set(_exe_extension "")
if(WIN32)
  set(_exe_extension ".exe")
endif()

add_external_project(ispc
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ispc${_exe_extension} <INSTALL_DIR>/bin/
  )
