find_package(Blosc2 REQUIRED NO_MODULE)

superbuild_add_extra_cmake_args(
  -DBlosc2_DIR:PATH=${Blosc2_DIR})
