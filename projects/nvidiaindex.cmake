if (APPLE)
  message(FATAL_ERROR
    "NVIDIA IndeX is not supported on macOS.")
endif ()

if (superbuild_build_phase AND "x${CMAKE_CXX_COMPILER_ID}" STREQUAL "xMSVC")
  if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "18.0" OR
      NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS "19.0")
    message(FATAL_ERROR
      "NVIDIA IndeX only provides libraries for MSVC 2013.")
  endif ()
endif ()

superbuild_add_project(nvidiaindex
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dsource_dir:PATH=<SOURCE_DIR>
      -Dinstall_dir:PATH=<INSTALL_DIR>
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/nvidiaindex.install.cmake")
