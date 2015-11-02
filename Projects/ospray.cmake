set(OSPRAY_BUILD_ISA "AVX" CACHE STRING "Target ISA for OSPray (SSE, AVX, AVX2 or ALL).")
set_property(CACHE OSPRAY_BUILD_ISA PROPERTY STRINGS SSE AVX AVX2 ALL)
mark_as_advanced(OSPRAY_BUILD_ISA)

add_external_project(ospray
  DEPENDS ispc
  CMAKE_ARGS
    -DOSPRAY_ISPC_DIRECTORY:PATH=<INSTALL_DIR>/bin
    -DOSPRAY_BUILD_ISA:STRING=${OSPRAY_BUILD_ISA}
  )

# OSPRay's CMakeLists hard-codes the install path to /tmp/<user>/...
# This patch fixes that.
add_external_project_step(patch_fix_install
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
  ${SuperBuild_PROJECTS_DIR}/patches/ospray.CMakeLists.txt
  <SOURCE_DIR>/CMakeLists.txt
  DEPENDEES update # do after update
  DEPENDERS patch  # do before patch
  )

add_extra_cmake_args(
  -DOSPRAY_DIR:PATH=${SuperBuild_BINARY_DIR}/ospray/src/ospray
  -DOSPRAY_CMAKE_DIR:PATH=${SuperBuild_BINARY_DIR}/ospray/src/ospray/cmake/
  -DOSPRAY_BUILD_DIR:PATH=${SuperBuild_BINARY_DIR}/ospray/src/ospray-build
  -DLIB_OSPRAY:PATH=${SuperBuild_BINARY_DIR}/ospray/src/ospray-build/lib
  -DLIB_OSPRAY_EMBREE:PATH=${SuperBuild_BINARY_DIR}/ospray/src/ospray-build
)
