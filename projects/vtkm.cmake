if (ENABLE_vtkm AND (WIN32 AND MSVC AND (MSVC_VERSION LESS 1900)))
  message(FATAL_ERROR "VTK-m is not supported on MSVC 2013 and older. Please set ENABLE_vtkm to OFF.")
endif()

superbuild_add_dummy_project(vtkm)
