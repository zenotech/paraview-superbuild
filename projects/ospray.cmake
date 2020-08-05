set(ospray_isa_default "ALL")
if (DEFINED OSPRAY_BUILD_ISA)
  message(WARNING "The OSPRAY_BUILD_ISA setting is deprecated in favor of ospray_BUILD_ISA.")
  set(ospray_isa_default "${OSPRAY_BUILD_ISA}")
endif ()

set(ospray_BUILD_ISA "${ospray_isa_default}"
  CACHE STRING "Target ISA for OSPRay (SSE, AVX, AVX2, AVX512KNL, AVX512SKX, or ALL).")
mark_as_advanced(ospray_BUILD_ISA)
set_property(CACHE ospray_BUILD_ISA PROPERTY STRINGS SSE AVX AVX2 AVX512KNL AVX512SKX ALL)

set (ospray_depends ispc tbb cxx11 embree ospraymaterials openimagedenoise
  ospcommon openvkl)

superbuild_add_project(ospray
  DEPENDS ${ospray_depends}
  CMAKE_ARGS
    -DOSPRAY_ISPC_DIRECTORY:PATH=<INSTALL_DIR>/bin
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DOSPRAY_BUILD_ISA:STRING=${ospray_BUILD_ISA}
    -DOSPRAY_APPS_EXAMPLES:BOOL=OFF
    -DOSPRAY_APPS_TESTING:BOOL=OFF
    -DOSPRAY_ENABLE_APPS:BOOL=OFF
    -DOSPRAY_MODULE_DENOISER:BOOL=ON
)

superbuild_add_extra_cmake_args(
  -DOSPRAY_INSTALL_DIR:PATH=<INSTALL_DIR>)

superbuild_apply_patch(ospray anchor-libraries "assist with dynamic library resolution")
