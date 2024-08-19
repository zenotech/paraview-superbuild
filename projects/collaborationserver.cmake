set(collaborationserver_options)
if (UNIX AND NOT APPLE)
  list(APPEND collaborationserver_options
    -DCMAKE_INSTALL_RPATH:STRING=<INSTALL_DIR>/lib)
endif ()

superbuild_add_project(collaborationserver
  DEPENDS cppzmq zeromq
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    Apache-2.0
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2024 Kitware Inc."
  CMAKE_ARGS
    ${collaborationserver_options})
