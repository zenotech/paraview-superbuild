
superbuild_add_project(openvr
  LICENSE_FILES
    LICENSE
  DEPENDS openxrsdk
  CMAKE_ARGS
    -DBUILD_SHARED:BOOL=TRUE
  INSTALL_COMMAND
  "${CMAKE_COMMAND}"
    -Dsource_location:PATH=<SOURCE_DIR>
    -Dinstall_location:PATH=<INSTALL_DIR>
    -P ${CMAKE_CURRENT_LIST_DIR}/scripts/openvr.install.cmake
  )

superbuild_add_extra_cmake_args(
  -DOpenVR_INCLUDE_DIR:PATH=<INSTALL_DIR>/include/openvr
  -DOpenVR_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/${CMAKE_IMPORT_LIBRARY_PREFIX}openvr_api${CMAKE_IMPORT_LIBRARY_SUFFIX}
  -DVTK_MODULE_ENABLE_VTK_RenderingOpenXR:STRING=WANT
  -DOpenXR_INCLUDE_DIR:PATH=<INSTALL_DIR>/include/openxr
  -DOpenXR_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/${CMAKE_IMPORT_LIBRARY_PREFIX}openxr_loader${CMAKE_IMPORT_LIBRARY_SUFFIX}
  )
