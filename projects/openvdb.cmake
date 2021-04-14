superbuild_add_project(openvdb
  DEPENDS tbb cxx14 blosc zlib boost
  CMAKE_ARGS
    -DUSE_BLOSC:BOOL=ON
    -DUSE_ZLIB:BOOL=ON
    -DCMAKE_INSTALL_LIBDIR:PATH=lib)

superbuild_add_extra_cmake_args(
  -DOpenVDB_CMAKE_PATH:PATH=<INSTALL_DIR>/lib/cmake/OpenVDB
)
