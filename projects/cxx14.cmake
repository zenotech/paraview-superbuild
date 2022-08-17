superbuild_add_dummy_project(cxx14)

if (cxx14_enabled)
  set(CMAKE_CXX_STANDARD 14)
  set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

  add_library(cxx14_check
    "${CMAKE_CURRENT_LIST_DIR}/scripts/cxx14.cxx")
endif ()

superbuild_add_extra_cmake_args(
  -DCMAKE_CXX_STANDARD:STRING=14
  -DCMAKE_CXX_STANDARD_REQUIRED:STRING=TRUE)

superbuild_append_flags(cxx_flags "${CMAKE_CXX14_STANDARD_COMPILE_OPTION}")
