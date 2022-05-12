superbuild_add_project(openvdb
  DEPENDS tbb cxx14 blosc zlib boost
  LICENSE_FILES
    LICENSE
  CMAKE_ARGS
    -DUSE_BLOSC:BOOL=ON
    -DUSE_ZLIB:BOOL=ON
    -DOPENVDB_CORE_STATIC:BOOL=OFF
    -DCMAKE_INSTALL_LIBDIR:PATH=lib)

superbuild_add_extra_cmake_args(
  -DOpenVDB_CMAKE_PATH:PATH=<INSTALL_DIR>/lib/cmake/OpenVDB
)

superbuild_apply_patch(openvdb tbb-disable-autolink
  "Disable TBB autolinking")
superbuild_apply_patch(openvdb findtbb-no-stddef-header
  "Support newer TBB version header searching")
