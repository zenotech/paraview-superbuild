find_package(adios2 REQUIRED NO_MODULE)

superbuild_add_extra_cmake_args(
   -DADIOS2_DIR:PATH=${adios2_DIR}
   -Dadios2_DIR:PATH=${adios2_DIR})
