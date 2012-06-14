
add_external_project(mesa
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --disable-static
                    --enable-shared
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
