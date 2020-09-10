superbuild_add_project(openvkl
  DEPENDS ispc tbb cxx11 embree rkcommon
  CMAKE_ARGS
    -DBUILD_BENCHMARKS:BOOL=OFF
    -DBUILD_EXAMPLES:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DISPC_EXECUTABLE:PATH=<INSTALL_DIR>/bin/ispc)

superbuild_apply_patch(openvkl anchor-libraries "assist with dynamic library resolution")
