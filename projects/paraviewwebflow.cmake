superbuild_add_project(paraviewwebflow
  # TODO Add a license
  # https://gitlab.kitware.com/paraview/paraview-superbuild/-/issues/218
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
    -Dsource_location:PATH=<SOURCE_DIR>
    -Dinstall_location:PATH=<INSTALL_DIR>
    -P "${CMAKE_CURRENT_LIST_DIR}/scripts/paraviewwebflow.install.cmake")
