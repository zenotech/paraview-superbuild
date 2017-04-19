set(plugin_project acusolve)
set(acusolve_name AcuSolveReaderPlugin)
set(acusolve_install_files
  <BINARY_DIR>/${CMAKE_SHARED_LIBRARY_PREFIX}AcuSolveReader${CMAKE_SHARED_LIBRARY_SUFFIX})
set(acusolve_fixup_plugin_paths
  "<INSTALL_DIR>/lib/Qt=@executable_path/../Frameworks/Qt"
  "<INSTALL_DIR>/lib/=@executable_path/../Libraries/"
  "libhdf5.7.3.0.dylib=@executable_path/../Libraries/libhdf5.1.8.9.dylib"
  "libhdf5_hl.7.3.0.dylib=@executable_path/../Libraries/libhdf5.1.8.9.dylib")

include(paraview.plugin)
