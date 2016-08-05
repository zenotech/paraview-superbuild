set(plugin_project vistrails)
set(vistrails_name VisTrailsPlugin)
set(vistrails_install_files
  <SOURCE_DIR>/README
  <BINARY_DIR>/${CMAKE_SHARED_LIBRARY_PREFIX}VisTrailsPlugin${CMAKE_SHARED_LIBRARY_SUFFIX})
set(vistrails_fixup_plugin_paths
  "<INSTALL_DIR>/lib/Qt=@executable_path/../Frameworks/Qt"
  "<INSTALL_DIR>/lib/=@executable_path/../Libraries/"
  "libhdf5.7.3.0.dylib=@executable_path/../Libraries/libhdf5.1.8.9.dylib"
  "libhdf5_hl.7.3.0.dylib=@executable_path/../Libraries/libhdf5.1.8.9.dylib"
  "libcgns.3.1.dylib=@executable_path/../Libraries/libcgns.3.1.dylib")

include(paraview.plugin)
