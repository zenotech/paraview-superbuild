if (BUILD_SHARED_LIBS)
  set(glu_flags --disable-static --enable-shared)
  set(glu_library libGLU.so)
else ()
  set(glu_flags --enable-static --disable-shared)
  set(glu_library libGLU.a)
endif ()

superbuild_add_project(glu
  CAN_USE_SYSTEM
  DEPENDS_OPTIONAL mesa
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
    --prefix=<INSTALL_DIR>
    ${glu_flags}
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install
  BUILD_IN_SOURCE 1)

superbuild_add_extra_cmake_args(
  -DOPENGL_glu_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/${glu_library})
