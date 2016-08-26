find_package(EGL REQUIRED)

# This will add PYTHON_LIBRARY, PYTHON_EXECUTABLE, PYTHON_INCLUDE_DIR
# variables. User can set/override these to change the Python being used.
superbuild_add_extra_cmake_args(
  -DEGL_INCLUDE_DIR:PATH=${EGL_INCLUDE_DIR}
  -DEGL_gldispatch_LIBRARY:FILEPATH=${EGL_gldispatch_LIBRARY}
  -DEGL_LIBRARY:FILEPATH=${EGL_LIBRARY}
  -DVTK_USE_OFFSCREEN_EGL:BOOL=ON
  -DVTK_USE_OFFSCREEN:BOOL=OFF
  -DVTK_USE_X:BOOL=OFF)
