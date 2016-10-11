find_package(OpenGL REQUIRED)
if (NOT OPENGL_GLU_FOUND)
  message(FATAL_ERROR "Failed to find `GLU`.")
endif ()

superbuild_add_extra_cmake_args(
  -DOPENGL_glu_LIBRARY:FILEPATH=${OPENGL_glu_LIBRARY})
