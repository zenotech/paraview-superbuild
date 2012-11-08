set (_install_location "<INSTALL_DIR>")

add_external_project(matplotlib
  DEPENDS python numpy png freetype
  PATCH_COMMAND
    ${CMAKE_COMMAND}
      "-DPATCHES_DIR:PATH=${SuperBuild_PROJECTS_DIR}/patches/"
      "-DPATCH_OUTPUT_DIR:PATH=${CMAKE_BINARY_DIR}"
      "-DSOURCE_DIR:PATH=<SOURCE_DIR>"
      "-DINSTALL_DIR:PATH=<INSTALL_DIR>"
      -P "${CMAKE_CURRENT_LIST_DIR}/matplotlib.patch.cmake"
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
