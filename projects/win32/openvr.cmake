
superbuild_add_project(openvr
  CMAKE_ARGS
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    )

# apply some fixes to the CMakeList files for OpenVR
#
# apply MR https://github.com/ValveSoftware/openvr/pull/634
# apply MR https://github.com/ValveSoftware/openvr/pull/483
#
superbuild_apply_patch(openvr improve-install
  "Improve OpenVR Install")

superbuild_add_extra_cmake_args(
  -DOPENVR_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DOPENVR_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}openvr_api64${CMAKE_STATIC_LIBRARY_SUFFIX}
  )
