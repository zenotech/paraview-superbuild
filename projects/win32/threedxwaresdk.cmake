superbuild_add_project(threedxwaresdk
  LICENSE_FILES
    LicenseAgreementSDK.txt
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dsource_dir:PATH=<SOURCE_DIR>
      -Dinstall_dir:PATH=<INSTALL_DIR>
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/threedxwaresdk.install.cmake"
)

superbuild_add_extra_cmake_args(
  -D3DxWareSDK_ROOT:PATH=<INSTALL_DIR>
)
