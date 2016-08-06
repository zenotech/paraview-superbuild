superbuild_add_project(paraviewwebvisualizer
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
    -Dsource_location:PATH=<SOURCE_DIR>
    -Dinstall_location:PATH=<INSTALL_DIR>
    -P "${CMAKE_CURRENT_LIST_DIR}/scripts/paraviewwebvisualizer.install.cmake")

# TODO: Install into packages when ParaView no longer ships its paraviewweb
# stuff.
