add_external_project_or_use_system(osmesa
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --with-driver=osmesa
                    --with-gallium-drivers=
                    --enable-shared
                    --disable-static
  BUILD_IN_SOURCE 1
)

add_extra_cmake_args(
  -DOPENGL_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DOPENGL_gl_LIBRARY:FILEPATH=
  -DOPENGL_glu_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/libGLU.so
  -DOSMESA_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DOSMESA_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/libOSMesa.so
)
