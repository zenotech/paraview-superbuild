superbuild_add_project(nvidiaoptix
  LICENSE_FILES
    "${CMAKE_CURRENT_LIST_DIR}/files/NVIDIA-OptiX-SDK-6.0.0-EULA.txt" # The package only provides a license in .pdf format
    doc/OptiX_ThirdParty_Licenses.txt
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
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/nvidiaoptix.install.cmake"
  INSTALL_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/scripts/nvidiaoptix.install.cmake")

superbuild_add_extra_cmake_args(
  -DOptiX_ROOT:PATH=<INSTALL_DIR>)

superbuild_apply_patch(nvidiaoptix cuda-12
  "Support CUDA 12")
