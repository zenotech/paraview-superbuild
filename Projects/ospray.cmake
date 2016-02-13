set(OSPRAY_BUILD_ISA "AVX" CACHE STRING "Target ISA for OSPray (SSE, AVX, AVX2 or ALL).")
set_property(CACHE OSPRAY_BUILD_ISA PROPERTY STRINGS SSE AVX AVX2 ALL)
mark_as_advanced(OSPRAY_BUILD_ISA)

add_external_project(ospray
  DEPENDS ispc
  CMAKE_ARGS
    -DOSPRAY_ISPC_DIRECTORY:PATH=<INSTALL_DIR>/bin
    -DOSPRAY_BUILD_ISA:STRING=${OSPRAY_BUILD_ISA}
  )

add_extra_cmake_args(
  -DOSPRAY_SOURCE:PATH=${SuperBuild_BINARY_DIR}/ospray/src/ospray
  -DOSPRAY_CMAKE_DIR:PATH=${SuperBuild_BINARY_DIR}/ospray/src/ospray/cmake/
  -DOSPRAY_BUILD:PATH=${SuperBuild_BINARY_DIR}/ospray/src/ospray-build
)
