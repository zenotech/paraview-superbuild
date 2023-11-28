superbuild_add_project(openvr
  LICENSE_FILES
    LICENSE
    # https://github.com/ValveSoftware/openvr/issues/1763
    # LICENSE.jsoncpp
  SPDX_LICENSE_IDENTIFIER
    "BSD-3-Clause AND MIT"
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2015, Valve Corporation"
    "Copyright (c) 2007-2010 Baptiste Lepilleur and The JsonCpp Authors"
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
