set(OSPRAY_BUILD_ISA "AVX" CACHE STRING "Target ISA for OSPray (SSE, AVX, AVX2 or ALL).")
set_property(CACHE OSPRAY_BUILD_ISA PROPERTY STRINGS SSE AVX AVX2 ALL)
mark_as_advanced(OSPRAY_BUILD_ISA)

add_external_project(ospray
  DEPENDS ispc tbb
  CMAKE_ARGS
    -DTBB_ROOT:PATH=<INSTALL_DIR>
    -DOSPRAY_ISPC_DIRECTORY:PATH=<INSTALL_DIR>/bin
    -DOSPRAY_BUILD_ISA:STRING=${OSPRAY_BUILD_ISA}
    -DOSPRAY_APPS_MODELVIEWER:BOOL=OFF
    -DOSPRAY_APPS_PARTICLEVIEWER:BOOL=OFF
    -DOSPRAY_APPS_QTVIEWER:BOOL=OFF
    -DOSPRAY_APPS_STREAMLINEVIEWER:BOOL=OFF
    -DOSPRAY_APPS_VOLUMEVIEWER:BOOL=OFF
    -DOSPRAY_MODULE_LOADERS:BOOL=OFF
    -DOSPRAY_MODULE_OPENGL_UTIL:BOOL=OFF
    -DOSPRAY_MODULE_SEISMIC:BOOL=OFF
    -DOSPRAY_MODULE_TACHYON:BOOL=OFF
  )

if (WIN32)
  add_external_project_step(patch_osprayFindTBB
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${SuperBuild_PROJECTS_DIR}/patches/ospray.FindTBB.cmake"
            "<SOURCE_DIR>/cmake/FindTBB.cmake"
    DEPENDEES update # do after update
  )
  add_external_project_step(patch_embreeFindTBB
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${SuperBuild_PROJECTS_DIR}/patches/ospray.FindTBB.cmake"
            "<SOURCE_DIR>/ospray/embree-v2.7.1/common/cmake/FindTBB.cmake"
    DEPENDEES patch_osprayFindTBB # do after ospray patch
    DEPENDERS configure  # do before configure
  )
endif()

add_extra_cmake_args(
  -DOSPRAY_INSTALL_DIR:PATH=<INSTALL_DIR>
)
