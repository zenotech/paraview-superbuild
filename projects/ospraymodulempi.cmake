superbuild_add_project(ospraymodulempi
  DEPENDS ospray mpi ispc tbb cxx11
  CMAKE_ARGS
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DCMAKE_INSTALL_LIBDIR:STRING=lib)
