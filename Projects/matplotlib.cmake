set (_install_location "<INSTALL_DIR>")
if (WIN32)
  # matplotlib build has issues with paths containing "C:". So we set the prefix as a
  # relative path.
  set (_install_location "../../../install")
endif()

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

set(_force_c++11 FALSE)
if (APPLE AND "${cxxflags}" MATCHES "stdlib=libc\\+\\+")
  set(_force_c++11 TRUE)
endif()

add_external_project_or_use_system(matplotlib
  DEPENDS python numpy png freetype
  CONFIGURE_COMMAND
    "${SAFE_CMAKE_COMMAND}"
      "-DPATCHES_DIR:PATH=${SuperBuild_PROJECTS_DIR}/patches/"
      "-DPATCH_OUTPUT_DIR:PATH=${CMAKE_BINARY_DIR}"
      "-DSOURCE_DIR:PATH=<SOURCE_DIR>"
      "-DINSTALL_DIR:PATH=<INSTALL_DIR>"
      "-DFORCE_C++11:BOOL=${_force_c++11}"
      -P "${SuperBuild_PROJECTS_DIR}/matplotlib.patch.cmake"
  INSTALL_COMMAND ""
  BUILD_IN_SOURCE 1
  BUILD_COMMAND
    "${SAFE_CMAKE_COMMAND}" -DPYTHON_EXECUTABLE:PATH=${pv_python_executable}
                            -DMATPLOTLIB_SOURCE_DIR:PATH=<SOURCE_DIR>
                            -DMATPLOTLIB_INSTALL_DIR:PATH=${_install_location}
                            -DNUMPY_INSTALL_DIR:PATH=<INSTALL_DIR>
                            -P ${SuperBuild_PROJECTS_DIR}/matplotlib.build.cmake
)
