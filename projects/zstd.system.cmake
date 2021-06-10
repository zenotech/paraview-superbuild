find_package(Zstd REQUIRED NO_MODULE)

superbuild_add_extra_cmake_args(
  -DZstd_DIR:PATH=${Zstd_DIR})
