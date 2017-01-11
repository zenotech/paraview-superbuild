set(mesa_swr_default ON)
if (DEFINED MESA_SWR_ENABLED)
  message(WARNING
    "The MESA_SWR_ENABLED setting is deprecated in favor of mesa_USE_SWR.")
  set(mesa_swr_default "${MESA_SWR_ENABLED}")
endif ()

option(mesa_USE_SWR "Enable the OpenSWR driver" "${mesa_swr_default}")
mark_as_advanced(mesa_USE_SWR)

set(mesa_drivers swrast)
if (mesa_USE_SWR)
  list(APPEND mesa_drivers swr)
endif ()

option(mesa_USE_TEXTURE_FLOAT
  "Enable floating point textures via ARB_texture_float." OFF)
mark_as_advanced(mesa_USE_TEXTURE_FLOAT)

if (mesa_USE_TEXTURE_FLOAT)
  if (NOT mesa_use_texture_float_warned_once)
    message(WARNING
      "You have enabled floating point textures for Mesa.  Please be aware of "
      "the patent licencing issues associated with turning this on, see "
      "https://cgit.freedesktop.org/mesa/mesa/tree/docs/patents.txt "
      "for more details.  By enabling this you are accepting the associated "
      "legal responsibility.")
    set(mesa_use_texture_float_warned_once ON CACHE INTERNAL "")
  endif ()
  set(mesa_texture_float_args "--enable-texture-float")
else ()
  set(mesa_use_texture_float_warned_once OFF CACHE INTERNAL "")
  set(mesa_texture_float_args "--disable-texture-float")
endif ()

string(REPLACE ";" "," mesa_drivers "${mesa_drivers}")

# FIXME: need to use static llvm libs when appropriate

set(mesa_common_config_args
  --prefix=<INSTALL_DIR>
  --enable-opengl --disable-gles1 --disable-gles2
  --disable-va --disable-gbm --disable-xvmc --disable-vdpau
  --enable-shared-glapi
  ${mesa_texture_float_args}
  --disable-dri --with-dri-drivers=
  --enable-gallium-llvm --enable-llvm-shared-libs
  --with-llvm-prefix=${llvm_dir}
  --with-gallium-drivers=${mesa_drivers}
  --disable-egl --disable-gbm --with-egl-platforms=)

if (BUILD_SHARED_LIBS)
  set(mesa_shared_lib_args --enable-shared --disable-static)
else ()
  set(mesa_shared_lib_args --disable-shared --enable-static)
endif ()

if (CMAKE_CXX_COMPILER_ID MATCHES "Intel")
  superbuild_append_flags(
    cxx_flags "-diag-disable=177,873"
    PROJECT_ONLY)
endif ()

# We frequently need to patch the autoconf files so instead of making it patch
# dependent we just always use autogen instead of configure

superbuild_add_project(${project}
  CAN_USE_SYSTEM
  DEPENDS llvm ${mesa_type_deps}
  CONFIGURE_COMMAND
    ./autogen.sh
      ${mesa_common_config_args}
      ${mesa_shared_lib_args}
      ${mesa_type_args}
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install
  BUILD_IN_SOURCE 1)

# For compatibility on machines with a crufty autotools
superbuild_apply_patch(${project} revert-xz
  "Revert autoconf dist-xz to dist-bzip2")
