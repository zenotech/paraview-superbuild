set(mesa_type_args --disable-osmesa --disable-gallium-osmesa --enable-glx --with-platforms=x11)
set(mesa_type_deps glproto)
include(mesa.common)

if (BUILD_SHARED_LIBS)
  set(mesa_library libGL.so)
else ()
  set(mesa_library libGL.a)
endif ()
superbuild_add_extra_cmake_args(
  -DOPENGL_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DOPENGL_xmesa_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DOPENGL_gl_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/${mesa_library})
