superbuild_add_project(threedxwaresdk
  LICENSE_FILES
    LicenseAgreementSDK.txt
  SPDX_LICENSE_IDENTIFIER
    LicenseRef-threedxwaresdk
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 3Dconnexion"
  SPDX_CUSTOM_LICENSE_FILE
    LicenseAgreementSDK.txt
  SPDX_CUSTOM_LICENSE_NAME
    LicenseRef-threedxwaresdk
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dsource_dir:PATH=<SOURCE_DIR>
      -Dinstall_dir:PATH=<INSTALL_DIR>
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/threedxwaresdk.install.cmake"
  INSTALL_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/scripts/threedxwaresdk.install.cmake"
)

superbuild_apply_patch(threedxwaresdk windows-include
  "Add missing Windows include")

superbuild_add_extra_cmake_args(
  -D3DxWareSDK_ROOT:PATH=<INSTALL_DIR>
)
