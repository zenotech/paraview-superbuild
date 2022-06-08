file(INSTALL "${source_dir}/lib/${host_proc}/3DconnexionNavlib"
  DESTINATION "${install_dir}/lib")

# grab headers, including the "navlib" and "SpaceMouse" directories
file(INSTALL "${source_dir}/include/"
  DESTINATION "${install_dir}/include"
  FILES_MATCHING
    PATTERN "*.h"
    PATTERN "*.hpp")
