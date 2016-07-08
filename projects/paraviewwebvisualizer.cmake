superbuild_add_project(paraviewwebvisualizer
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
    -Dsource_dir:PATH=<SOURCE_DIR>
    -Dinstall_location:PATH=<INSTALL_DIR>
    -P "${CMAKE_CURRENT_LIST_DIR}/scripts/paraviewwebvisualizer.install.cmake")
