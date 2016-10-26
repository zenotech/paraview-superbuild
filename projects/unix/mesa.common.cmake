option(mesa_USE_SWR "Enable the OpenSWR driver" ON)
mark_as_advanced(mesa_USE_SWR)
if (MESA_SWR_ENABLED)
  message(WARNING "The MESA_SWR_ENABLED setting is deprecated in favor of mesa_USE_SWR.")
  set(mesa_USE_SWR ${MESA_SWR_ENABLED} CACHE BOOL "Enable the OpenSWR driver" FORCE)
endif ()

set(mesa_drivers swrast)
if (mesa_USE_SWR)
  list(APPEND mesa_drivers swr)
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
  set(mesa_shared_lib_args --enable-shared --disable-static)
else ()
  set(mesa_shared_lib_args --disable-shared --enable-static)
endif ()

if (CMAKE_CXX_COMPILER_ID MATCHES "Intel")
  superbuild_append_flags(
    cxx_flags "-diag-disable=177,873"
    PROJECT_ONLY)
endif ()

if (mesa_SOURCE_SELECTION STREQUAL "git" OR
    (current_project       STREQUAL "osmesa" AND
     mesa_SOURCE_SELECTION STREQUAL "v12.0.3"))
  set(mesa_use_autogen ON)
endif ()

if (mesa_use_autogen)
  set(mesa_configure_cmd ./autogen.sh)
else ()
  set(mesa_configure_cmd ./configure)
endif ()

superbuild_add_project(${project}
  CAN_USE_SYSTEM
  DEPENDS llvm
  CONFIGURE_COMMAND
    ${mesa_configure_cmd}
      ${mesa_common_config_args}
      ${mesa_shared_lib_args}
      ${mesa_type_args}
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install
  BUILD_IN_SOURCE 1)

if (mesa_use_autogen)
  # For compatibility on machines with a crufty autotools
  superbuild_apply_patch(${project} revert-xz
    "Revert autoconf dist-xz to dist-bzip2")
endif ()
