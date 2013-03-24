add_external_project(osmesa
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --disable-shared
                    --enable-shared
                    --disable-static
                    --enable-osmesa
                    --without-x
                    --with-gallium-drivers=
                    --disable-dri
                    --disable-glx
                    --disable-egl
  BUILD_IN_SOURCE 1
)

add_extra_cmake_args(
  -DOPENGL_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DOPENGL_gl_LIBRARY:FILEPATH=
  -DOPENGL_glu_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/libGLU.so
  -DVTK_OPENGL_HAS_OSMESA:BOOL=ON
  -DOSMESA_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DOSMESA_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/libOSMesa.so
  -DVTK_USE_X:BOOL=OFF)
