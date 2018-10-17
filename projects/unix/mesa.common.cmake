set(mesa_swr_default ON)
if (DEFINED MESA_SWR_ENABLED)
  message(WARNING
    "The MESA_SWR_ENABLED setting is deprecated in favor of mesa_USE_SWR.")
  set(mesa_swr_default "${MESA_SWR_ENABLED}")
endif ()

option(mesa_USE_SWR "Enable the OpenSWR driver" "${mesa_swr_default}")
mark_as_advanced(mesa_USE_SWR)

set(mesa_SWR_ARCH "avx,avx2"
  CACHE STRING "backend architectures to be used by the SWR driver")
mark_as_advanced(mesa_USE_SWR_ARCH)
set_property(CACHE mesa_SWR_ARCH PROPERTY STRINGS
  "avx" "avx2" "knl" "skx"
  "avx,avx2" "avx2,knl" "knl,skx"
  "avx,avx2,knl" "avx,avx2,skx"
  "avx,avx2,knl,skx")

set(mesa_drivers swrast)
if (mesa_USE_SWR)
  list(APPEND mesa_drivers swr)
  set(mesa_swr_arch "--with-swr-archs=${mesa_SWR_ARCH}")
endif ()

string(REPLACE ";" "," mesa_drivers "${mesa_drivers}")

# FIXME: need to use static llvm libs when appropriate

set(mesa_common_config_args
  --prefix=<INSTALL_DIR>
  --enable-opengl --disable-gles1 --disable-gles2
  --disable-va --disable-gbm --disable-xvmc --disable-vdpau
  --disable-shared-glapi
  --disable-dri --with-dri-drivers=
  --enable-llvm
  --with-llvm-prefix=${llvm_dir}
  --with-gallium-drivers=${mesa_drivers}
  ${mesa_swr_arch}
  --disable-egl --disable-gbm)

if (BUILD_SHARED_LIBS)
  set(mesa_shared_lib_args --enable-shared --disable-static)
else ()
  set(mesa_shared_lib_args --disable-shared --enable-static)
endif ()

if (CMAKE_CXX_COMPILER_ID MATCHES "Intel")
  superbuild_append_flags(
    c_flags "-diag-disable=279,557,10006"
    PROJECT_ONLY)
  superbuild_append_flags(
    cxx_flags "-diag-disable=177,279,557,873,10006"
    PROJECT_ONLY)
endif ()

# We frequently need to patch the autoconf files so instead of making it patch
# dependent we just always use autogen instead of configure

superbuild_add_project(${project}
  CAN_USE_SYSTEM
  DEPENDS llvm zlib ${mesa_type_deps} expat pythonmako
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

# Fix some borked sed flags
superbuild_apply_patch(${project} sed-flags
  "Fix incompatible sed flags in configure")

# Fix a segfault when swr is not supported
superbuild_apply_patch(${project} swr-llvm7-support
  "Fix llvm7 build failure for swr")
