superbuild_add_project(nvidiamdl
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    ${CMAKE_COMMAND}
      -Dsource_location:PATH=<SOURCE_DIR>
      -Dinstall_location:PATH=<INSTALL_DIR>
      -Dlibdir:STRING=${nvidiamdl_libdir}
      -Dlibsuffix:STRING=${CMAKE_SHARED_MODULE_SUFFIX}
      -Dlibdest:STRING=${nvidiamdl_libdest}
      ${nvidiamdl_install_args}
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/nvidiamdl.install.cmake")

superbuild_add_extra_cmake_args(
  -DMDL_INSTALL_DIR:PATH=<INSTALL_DIR>)
