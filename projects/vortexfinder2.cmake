paraview_add_plugin(vortexfinder2
  PLUGIN_NAME VortexFinder2
  DEPENDS boost qt
  DEPENDS_OPTIONAL qt4 qt5)

# XXX: Remove when https://github.com/tjcorona/vortexfinder2/pull/2 is merged.
superbuild_add_extra_cmake_args(
  -DWITH_CXX11:BOOL=${cxx11_enabled}
  -DWITH_MACOS_RPATH:BOOL=FALSE)
