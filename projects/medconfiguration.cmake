superbuild_add_project(medconfiguration
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}" -E copy_directory
      <SOURCE_DIR>
      <INSTALL_DIR>/configuration)

superbuild_apply_patch(medconfiguration remove-unused-boost-component
  "Remove unused boost component from CMake logic")
