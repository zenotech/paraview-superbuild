if(BUILD_SHARED_LIBS)
  set(shared_args --enable-shared --disable-static)
else()
  set(shared_args --disable-shared --enable-static)
endif()

add_external_project(mesa
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    ${shared_args}
                    --enable-texture-float
                    --with-driver=xlib
                    # I wonder if this option makes it possible to use OSMesa
                    # and GL at same time.
                    --enable-gl-osmesa
                    # to keep mesa from requiring LLVM
                    --disable-gallium-llvm
                    --with-gallium-drivers=swrast
  BUILD_IN_SOURCE 1
)
