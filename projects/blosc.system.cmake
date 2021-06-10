find_package(Blosc REQUIRED NO_MODULE)

superbuild_add_extra_cmake_args(
  -DBlosc_DIR:PATH=${Blosc_DIR})
