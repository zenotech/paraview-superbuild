file(INSTALL "${source_dir}/lib/x64/TDxNavLib.lib"
  DESTINATION "${install_dir}/lib")

# grab headers, including the "navlib" directory
file(INSTALL "${source_dir}/inc/"
  DESTINATION "${install_dir}/include"
  FILES_MATCHING PATTERN "*.h")
# grab header-only C++ framework from a sample, copy SpaceMouse dir
file(INSTALL "${source_dir}/samples/navlib_viewer/src/SpaceMouse"
  DESTINATION "${install_dir}/include"
  FILES_MATCHING PATTERN "*.hpp")
