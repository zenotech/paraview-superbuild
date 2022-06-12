# Since this is a "framework", install the whole directory as a lib
file(INSTALL "${source_dir}/"
  DESTINATION "${install_dir}/lib"
  PATTERN ".DS_Store" EXCLUDE)

# grab headers, including the "navlib" and "SpaceMouse" directories
file(INSTALL "${source_dir}/3DconnexionNavlib.framework/Versions/A/Headers/"
  DESTINATION "${install_dir}/include"
  FILES_MATCHING
    PATTERN "*.h"
    PATTERN "*.hpp")
