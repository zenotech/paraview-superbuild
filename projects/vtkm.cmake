superbuild_add_project(vtkm
  DEFAULT_ON
  DEPENDS tbb
  CMAKE_ARGS
  -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
  -DVTKm_ENABLE_TBB:BOOL=${tbb_enabled}
  -DVTKm_ENABLE_RENDERING:BOOL=OFF
  -DVTKm_ENABLE_TESTING:BOOL=OFF
  -DTBB_ROOT:PATH=<INSTALL_DIR>)

superbuild_add_extra_cmake_args(
  -DVTKm_DIR:PATH=<INSTALL_DIR>/lib)

if (APPLE)
  superbuild_append_flags(cxx_flags "-stdlib=libc++" PROJECT_ONLY)
  superbuild_append_flags(ld_flags "-stdlib=libc++" PROJECT_ONLY)
endif ()
