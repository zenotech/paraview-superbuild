superbuild_add_project(embree
  DEPENDS ispc tbb cxx11
  CMAKE_ARGS
    -DEMBREE_TBB_ROOT:PATH=<INSTALL_DIR>
    -DEMBREE_ISPC_EXECUTABLE:PATH=<INSTALL_DIR>/bin/ispc
    -DEMBREE_GEOMETRY_HAIR:BOOL=OFF
    -DEMBREE_GEOMETRY_LINES:BOOL=OFF
    -DEMBREE_GEOMETRY_QUADS:BOOL=OFF
    -DEMBREE_GEOMETRY_SUBDIV:BOOL=OFF
    -DEMBREE_TUTORIALS:BOOL=OFF
    -DCMAKE_INSTALL_LIBDIR:STRING=lib)

superbuild_apply_patch(embree improve-findtbb
  "Improve FindTBB")
superbuild_apply_patch(embree fix-cray
  "Fix compilation under Cray Wrapper")
