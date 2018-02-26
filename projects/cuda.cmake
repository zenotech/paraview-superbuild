superbuild_add_dummy_project(cuda)

if (cuda_enabled AND NOT CMAKE_VERSION VERSION_LESS "3.8.0")
  enable_language(CUDA)
elseif(cuda_enabled)
  find_package(CUDA REQUIRED)
endif()
