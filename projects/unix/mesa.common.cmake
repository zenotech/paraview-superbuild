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
  set(mesa_swr_arch "-Dswr-arches=${mesa_SWR_ARCH}")
endif ()

string(REPLACE ";" "," mesa_drivers "${mesa_drivers}")

# FIXME: need to use static llvm libs when appropriate

set(mesa_common_config_args
  --libdir lib
  -Dprefix=<INSTALL_DIR>
  ${mesa_swr_arch}
  -Dauto_features=disabled
  -Dgallium-drivers=swrast,swr
  -Dvulkan-drivers=
  -Ddri-drivers=
  -Dshared-glapi=enabled
  -Degl=disabled
  -Dllvm=enabled
  -Dshared-llvm=enabled
  -Dgles1=disabled
  -Dgles2=disabled)

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
  DEPENDS llvm zlib ${mesa_type_deps} expat pythonmako meson python3
  CONFIGURE_COMMAND
    meson
      ${mesa_common_config_args}
      ${mesa_type_args}
      build
  BUILD_COMMAND
    ${superbuild_ninja_command} -C build
  INSTALL_COMMAND
    ${superbuild_ninja_command} -C build install
  BUILD_IN_SOURCE 1)

superbuild_append_flags(ld_flags
  "-Wl,-rpath,<INSTALL_DIR>/lib"
  PROJECT_ONLY)
