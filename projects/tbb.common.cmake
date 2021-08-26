if (tbb_enabled AND CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "arm64")
  message(FATAL_ERROR
    "The TBB does not support non-x86_64 processors yet")
endif ()

if (NOT tbb_libsuffix)
  set(tbb_libsuffix ${CMAKE_SHARED_LIBRARY_SUFFIX})
  if (WIN32)
    set(tbb_libsuffix ${CMAKE_IMPORT_LIBRARY_SUFFIX})
  endif ()
endif ()

superbuild_add_project(tbb
  CAN_USE_SYSTEM
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    ${CMAKE_COMMAND}
      -Dsource_location:PATH=<SOURCE_DIR>/tbb${tbb_ver_paraview}
      -Dinstall_location:PATH=<INSTALL_DIR>
      -Dlibdir:STRING=${tbb_libdir}
      -Dlibsuffix:STRING=${tbb_libsuffix}
      -Dlibsuffixshared:STRING=${CMAKE_SHARED_LIBRARY_SUFFIX}
      -Dlibprefix:STRING=${CMAKE_SHARED_LIBRARY_PREFIX}
      ${tbb_install_args}
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/tbb.install.cmake")

superbuild_add_extra_cmake_args(
  -DTBB_ROOT:PATH=<INSTALL_DIR>)

if (CMAKE_CXX_COMPILER_ID MATCHES "Intel")
  # see discussion at https://github.com/intel/tbb/issues/158
  superbuild_apply_patch(tbb disable-futex
    "Disable futex to avoid problems on Intel compiler")
endif ()
