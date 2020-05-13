superbuild_add_project(ospcommon
  DEPENDS ispc tbb cxx11
  CMAKE_ARGS
    -DBUILD_TESTING:BOOL=OFF
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DOSPCOMMON_TASKING_SYSTEM:STRING=TBB)
