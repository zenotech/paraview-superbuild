if (superbuild_build_phase AND "x${CMAKE_CXX_COMPILER_ID}" STREQUAL "xMSVC")
  if (MSVC_VERSION VERSION_LESS 1800)
    message(FATAL_ERROR
      "NVIDIA IndeX requires MSVC 2013 or newer.")
  endif ()
endif ()

if (nvidiaindex_SOURCE_SELECTION VERSION_GREATER_EQUAL "5.12")
  set(nvidiaindex_eula_txt "EULA.txt")
else ()
  # The package only provides a license in .pdf format
  set(nvidiaindex_eula_txt "${CMAKE_CURRENT_LIST_DIR}/files/NVIDIA-Index-EULA.txt")
endif ()

superbuild_add_project(nvidiaindex
  LICENSE_FILES
    "${nvidiaindex_eula_txt}"
    README.txt
    license.txt
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dsource_dir:PATH=<SOURCE_DIR>
      -Dinstall_dir:PATH=<INSTALL_DIR>
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/nvidiaindex.install.cmake"
  INSTALL_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/scripts/nvidiaindex.install.cmake")
