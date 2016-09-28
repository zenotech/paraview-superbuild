if (BUILD_SHARED_LIBS)
  set(mesa_library libGL.so)
else ()
  set(mesa_library libGL.a)
endif ()

include(mesa.common)

superbuild_add_project(mesa
  CAN_USE_SYSTEM
  DEPENDS llvm
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      ${mesa_common_config_args}
      --disable-gallium-osmesa
      --enable-glx
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install
  BUILD_IN_SOURCE 1)

superbuild_add_extra_cmake_args(
  -DOPENGL_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DOPENGL_xmesa_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DOPENGL_gl_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/${mesa_library}
  -DOPENGL_glu_LIBRARY:FILEPATH=)
