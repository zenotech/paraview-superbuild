if ( (NOT "${CMAKE_GENERATOR}" MATCHES "^NMake.*$") OR
     (NOT "${CMAKE_GENERATOR}" MATCHES "^Visual Studio.*$"))
  # Not use VS environment. We need to be pointed to nmake and devenv paths
  # since they are needed when building tools (qt, python, etc.).
  find_program(DEVENV_PATH NAMES devenv)
  mark_as_advanced(DEVENV_PATH)

  if (NOT DEVENV_PATH)
    message(FATAL_ERROR "Unable to find devenv; it is needed to build silo!")
  endif ()
endif ()

superbuild_add_project(silo
  DEPENDS zlib hdf5
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    "${CMAKE_COMMAND}"
      -Dsource_dir:PATH=<SOURCE_DIR>
      -Dinstall_dir:PATH=<INSTALL_DIR>
      -P ${CMAKE_CURRENT_LIST_DIR}/scripts/silo.configure.cmake
  BUILD_COMMAND
    "${CMAKE_COMMAND}"
      -D64bit_build:BOOL=${superbuild_is_64bit}
      -Dsource_dir:PATH=<SOURCE_DIR>
      -Dinstall_dir:PATH=<INSTALL_DIR>
      -DDEVENV_PATH:FILEPATH=${DEVENV_PATH}
      -P ${CMAKE_CURRENT_LIST_DIR}/scripts/silo.build.cmake
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -D64bit_build:BOOL=${superbuild_is_64bit}
      -Dsource_dir:PATH=<SOURCE_DIR>
      -Dinstall_dir:PATH=<INSTALL_DIR>
      -P ${CMAKE_CURRENT_LIST_DIR}/scripts/silo.install.cmake)

superbuild_apply_patch(silo fix-vcproj-quotation
  "Fix quotation in project files")
superbuild_apply_patch(silo fix-zlib-link
  "Fix zlib library name")

superbuild_add_extra_cmake_args(
  -DSILO_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DSILO_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/silohdf5.lib)
