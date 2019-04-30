superbuild_add_project(nvidiaoptix
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    ${CMAKE_COMMAND}
      -Dsource_location:PATH=<SOURCE_DIR>
      -Dinstall_location:PATH=<INSTALL_DIR>
      -Dlibdir:STRING=${nvidiaoptix_libdir}
      -Dlibsuffix:STRING=${nvidiaoptix_libsuffix}
      -Dlibdest:STRING=${nvidiaoptix_libdest}
      -Dbindir:STRING=${nvidiaoptix_bindir}
      -Dbinsuffix:STRING=${nvidiaoptix_binsuffix}
      -Dbindest:STRING=${nvidiaoptix_bindest}
      ${nvidiaoptix_install_args}
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/nvidiaoptix.install.cmake")

superbuild_add_extra_cmake_args(
  -DOptiX_ROOT:PATH=<INSTALL_DIR>)
