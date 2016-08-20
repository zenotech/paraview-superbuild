if (BUILD_SHARED_LIBS)
  set(osmesa_library libOSMesa.so)
else ()
  set(osmesa_library libOSMesa.a)
endif ()

include(mesa.common)

superbuild_add_project(osmesa
  CAN_USE_SYSTEM
  DEPENDS llvm
  CONFIGURE_COMMAND
    ./autogen.sh
      ${mesa_common_config_args}
      --enable-gallium-osmesa
      --disable-glx
  BUILD_IN_SOURCE 1)

superbuild_apply_patch(osmesa install-headers
  "Install OSMesa headers")

superbuild_add_extra_cmake_args(
  -DOPENGL_INCLUDE_DIR:PATH=
  -DOPENGL_xmesa_INCLUDE_DIR:PATH=
  -DOPENGL_gl_LIBRARY:FILEPATH=
  -DOPENGL_glu_LIBRARY:FILEPATH=
  -DOSMESA_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DOSMESA_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/${osmesa_library})
