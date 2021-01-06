find_package(Eigen3 REQUIRED NO_MODULE)

superbuild_add_extra_cmake_args(
   -DEigen3_DIR=${Eigen3_DIR}
   -DEigen3_INCLUDE_DIR:PATH=${EIGEN3_INCLUDE_DIR}
   -DEIGEN3_INCLUDE_DIR:PATH=${EIGEN3_INCLUDE_DIR})
