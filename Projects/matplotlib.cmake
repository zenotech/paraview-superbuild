set (_install_location "<INSTALL_DIR>")

configure_file("${SuperBuild_PROJECTS_DIR}/patches/matplotlib.setup.cfg.in"
  "${CMAKE_BINARY_DIR}/matplotlib.setup.cfg")

add_external_project(matplotlib
  DEPENDS python numpy png freetype
  PATCH_COMMAND
    ${CMAKE_COMMAND} -E copy_if_different
    "${CMAKE_BINARY_DIR}/matplotlib.setup.cfg"
    "<SOURCE_DIR>/setup.cfg"
  CONFIGURE_COMMAND ""
  INSTALL_COMMAND ""
  BUILD_IN_SOURCE 1

  BUILD_COMMAND
    ${CMAKE_COMMAND} -DPYTHON_EXECUTABLE:PATH=${pv_python_executable}
                     -DMATPLOTLIB_SOURCE_DIR:PATH=<SOURCE_DIR>
                     -DMATPLOTLIB_INSTALL_DIR:PATH=<INSTALL_DIR>
                     -DNUMPY_INSTALL_DIR:PATH=<INSTALL_DIR>
                     -P ${CMAKE_CURRENT_LIST_DIR}/matplotlib.build.cmake
)
