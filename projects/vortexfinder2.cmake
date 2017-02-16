paraview_add_plugin(vortexfinder2
  PLUGIN_NAME VortexFinder2
  DEPENDS boost qt cxx11
  DEPENDS_OPTIONAL qt4 qt5)

superbuild_add_extra_cmake_args(
  -DWITH_MACOS_RPATH:BOOL=FALSE)
