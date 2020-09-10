superbuild_add_project(rkcommon
  DEPENDS cxx11 tbb
  CMAKE_ARGS
     -DBUILD_TESTING:BOOL=OFF
     -DCMAKE_INSTALL_LIBDIR:STRING=lib
     -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
     -DINSTALL_DEPS:BOOL=OFF
)

superbuild_apply_patch(rkcommon allow-library-paths "assist with dynamic library resolution")
