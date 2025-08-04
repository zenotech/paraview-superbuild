superbuild_add_project(lookingglass
  DEPENDS qt
  DEPENDS_OPTIONAL
    qt5 qt6
  LICENSE_FILES
    LICENSE.txt
  SPDX_LICENSE_IDENTIFIER
    LicenseRef-LookingGlass
  SPDX_COPYRIGHT_TEXT
    "Copyright Looking Glass Factory Inc."
  SPDX_CUSTOM_LICENSE_FILE
    LICENSE.txt
  SPDX_CUSTOM_LICENSE_NAME
    LicenseRef-LookingGlass
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dsource_dir:PATH=<SOURCE_DIR>
      -Dinstall_dir:PATH=<INSTALL_DIR>
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/lookingglass.install.cmake"
  INSTALL_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/scripts/lookingglass.install.cmake"
)

# Just switch here for simplicity
set(libpath)
if(WIN32)
  # Note - the .lib should be placed in lib instead of bin.
  # Need to fix the install rule for the lib
  set(libpath bin/HoloPlayCore.lib)
elseif(APPLE)
  set(libpath lib/libHoloPlayCore.dylib)
else()
  set(libpath lib/libHoloPlayCore.so)
endif()

superbuild_add_extra_cmake_args(
  -DHoloPlayCore_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DHoloPlayCore_LIBRARY:FILEPATH=<INSTALL_DIR>/${libpath}
)
