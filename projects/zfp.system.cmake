find_package(zfp REQUIRED NO_MODULE)

superbuild_add_extra_cmake_args(
   -DZFP_DIR:PATH=${zfp_DIR}
   -Dzfp_DIR:PATH=${zfp_DIR})
