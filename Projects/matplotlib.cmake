set (_install_location "<INSTALL_DIR>")

# BUILD_COMMAND can't handle spaces in the executable name. Worse, for
# Makefile builds, it writes out a cmake script where ${CMAKE_COMMAND} can
# be expanded, while on ninja builds it just adds a new build rule to
# the build.ninja file, where ${CMAKE_COMMAND} cannot be interpreted. This
# should work if either (a) A Makefile generator is used with or without
# spaces in the CMake command path, or (b) Ninja is used with no spaces
# in the path.
set(SAFE_CMAKE_COMMAND "\\\${CMAKE_COMMAND}")
if(${CMAKE_GENERATOR} STREQUAL "Ninja")
  set(SAFE_CMAKE_COMMAND "${CMAKE_COMMAND}")
endif()

add_external_project(matplotlib
  DEPENDS python numpy png freetype
  PATCH_COMMAND
    ${CMAKE_COMMAND}
      "-DPATCHES_DIR:PATH=${SuperBuild_PROJECTS_DIR}/patches/"
      "-DPATCH_OUTPUT_DIR:PATH=${CMAKE_BINARY_DIR}"
      "-DSOURCE_DIR:PATH=<SOURCE_DIR>"
      "-DINSTALL_DIR:PATH=<INSTALL_DIR>"
      -P "${SuperBuild_PROJECTS_DIR}/matplotlib.patch.cmake"
  CONFIGURE_COMMAND ""
  INSTALL_COMMAND ""
  BUILD_IN_SOURCE 1
  BUILD_COMMAND
    "${SAFE_CMAKE_COMMAND}" -DPYTHON_EXECUTABLE:PATH=${pv_python_executable}
                            -DMATPLOTLIB_SOURCE_DIR:PATH=<SOURCE_DIR>
                            -DMATPLOTLIB_INSTALL_DIR:PATH=<INSTALL_DIR>
                            -DNUMPY_INSTALL_DIR:PATH=<INSTALL_DIR>
                            -P ${SuperBuild_PROJECTS_DIR}/matplotlib.build.cmake
)
