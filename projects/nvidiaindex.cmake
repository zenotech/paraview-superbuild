if (superbuild_build_phase AND "x${CMAKE_CXX_COMPILER_ID}" STREQUAL "xMSVC")
  if (MSVC_VERSION VERSION_LESS 1800 OR NOT MSVC_VERSION VERSION_LESS 2000)
    message(FATAL_ERROR
      "NVIDIA IndeX only provides libraries for MSVC 2013, MSVC 2015.")
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
