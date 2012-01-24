
add_external_project(
  mesa
  URL ftp://ftp.freedesktop.org/pub/mesa/7.11.2/MesaLib-7.11.2.tar.gz
  URL_MD5 b9e84efee3931c0acbccd1bb5a860554
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
