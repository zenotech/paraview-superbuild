cmake_dependent_option(MESA_SWR_ENABLED "Enable the SWR driver" ON
  "mesa_enabled" OFF)
mark_as_advanced(MESA_SWR_ENABLED)
set(mesa_drivers
  swrast)
if (MESA_SWR_ENABLED)
  list(APPEND mesa_drivers
    swr)
endif ()

string(REPLACE ";" "," mesa_drivers "${mesa_drivers}")

# FIXME: need to use static llvm libs when appropriate

set(mesa_common_config_args
  --prefix=<INSTALL_DIR>
  --enable-opengl --disable-gles1 --disable-gles2
  --disable-va --disable-gbm --disable-xvmc --disable-vdpau
  --enable-shared-glapi
  --disable-texture-float
  --disable-dri --with-dri-drivers=
  --enable-gallium-llvm --enable-llvm-shared-libs
  --with-llvm-prefix=${llvm_dir}
  --with-gallium-drivers=${mesa_drivers}
  --disable-egl --disable-gbm --with-egl-platforms=)
if (BUILD_SHARED_LIBS)
  list(APPEND mesa_common_config_args --enable-shared --disable-static)
else ()
  list(APPEND mesa_common_config_args --disable-shared --enable-static)
endif ()
