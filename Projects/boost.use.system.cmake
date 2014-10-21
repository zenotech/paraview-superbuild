find_package(Boost REQUIRED)

add_extra_cmake_args(
  -DBoost_NO_SYSTEM_PATHS:BOOL=ON
  -DBOOST_INCLUDEDIR:PATH=${Boost_INCLUDE_DIR}
)
