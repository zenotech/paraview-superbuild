set(openxrremoting_source_dir ${source_location}/build/native)
set(openxrremoting_bin_dir ${openxrremoting_source_dir}/bin/x64/Desktop)
set(openxrremoting_include_dir ${openxrremoting_source_dir}/include/openxr)

# grab all include files
file(
  INSTALL "${openxrremoting_include_dir}/"
  DESTINATION "${install_location}/include/openxrremoting")

# grab all dlls
file(
  INSTALL "${openxrremoting_bin_dir}/"
  DESTINATION "${install_location}/bin")
