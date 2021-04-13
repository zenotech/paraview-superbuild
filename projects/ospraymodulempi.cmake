superbuild_add_project(ospraymodulempi
  DEPENDS ospray mpi ispc tbb cxx11
  CMAKE_ARGS
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DCMAKE_INSTALL_LIBDIR:STRING=lib)

#fix-shareddata has been upstreamed and can be removed when ParaView's OSPRay reaches version 2.6
superbuild_apply_patch(ospraymodulempi fix-shareddata "backport sharedbuffer double commit fix")
