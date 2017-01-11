set(mesa_type_args --disable-gallium-osmesa --enable-glx)
set(mesa_type_deps glproto)
include(mesa.common)

superbuild_apply_patch(mesa use-glproto-for-all-glx-impls
  "Use GLProto for all GLX implementations")

if (BUILD_SHARED_LIBS)
  set(mesa_library libGL.so)
else ()
  set(mesa_library libGL.a)
endif ()
superbuild_add_extra_cmake_args(
  -DOPENGL_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DOPENGL_xmesa_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DOPENGL_gl_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/${mesa_library})
