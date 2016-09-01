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

# For compatibility on machines with a crufty autotools
superbuild_apply_patch(osmesa revert-xz
  "Revert autoconf dist-xz to dist-bzip2")

superbuild_add_extra_cmake_args(
  -DOPENGL_INCLUDE_DIR:PATH=IGNORE
  -DOPENGL_xmesa_INCLUDE_DIR:PATH=IGNORE
  -DOPENGL_gl_LIBRARY:FILEPATH=IGNORE
  -DOPENGL_glu_LIBRARY:FILEPATH=IGNORE
  -DOSMESA_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DOSMESA_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/${osmesa_library})
