if(BUILD_SHARED_LIBS)
  set(shared_args --enable-shared --disable-static)
  set(OSMESALIB libOSMesa.so)
else()
  set(shared_args --disable-shared --enable-static)
  set(OSMESALIB libOSMesa.a)
endif()
add_external_project_or_use_system(osmesa
  DEPENDS llvm
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
    --prefix=<INSTALL_DIR>
    --enable-opengl --disable-gles1 --disable-gles2
    --disable-va --disable-gbm --disable-xvmc --disable-vdpau
    --enable-shared-glapi
    --disable-texture-float
    --disable-dri --with-dri-drivers=
    --enable-gallium-llvm
    --enable-llvm-shared-libs   # FIXME: need to use static when llvm is static
    --with-gallium-drivers=swrast,swr
    --disable-egl --disable-gbm --with-egl-platforms=
    --enable-gallium-osmesa
    --disable-glx
    --with-llvm-prefix=${LLVM_DIR}
    ${shared_args}
  BUILD_IN_SOURCE 1
)

add_extra_cmake_args(
  -DOPENGL_INCLUDE_DIR:PATH=
  -DOPENGL_xmesa_INCLUDE_DIR:PATH=
  -DOPENGL_gl_LIBRARY:FILEPATH=
  -DOPENGL_glu_LIBRARY:FILEPATH=
  -DOSMESA_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DOSMESA_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/${OSMESALIB}
)
