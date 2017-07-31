set(embree_BUILD_ISA "DEFAULT" CACHE STRING "ISAs to build Embree for")
mark_as_advanced(embree_BUILD_ISA)
set(embree_isa_args)
if(NOT (embree_BUILD_ISA STREQUAL "DEFAULT"))
  if(embree_BUILD_ISA STREQUAL "ALL")
    set(embree_BUILD_ISA SSE2 SSE42 AVX AVX2 AVX512KNL AVX512SKX)
  endif()
  foreach(isa IN LISTS embree_BUILD_ISA)
    list(APPEND embree_isa_args -DEMBREE_ISA_${isa}:BOOL=ON)
  endforeach()
endif()

superbuild_add_project(embree
  DEPENDS ispc tbb cxx11
  CMAKE_ARGS
    ${embree_isa_args}
    -DEMBREE_TBB_ROOT:PATH=<INSTALL_DIR>
    -DEMBREE_ISPC_EXECUTABLE:PATH=<INSTALL_DIR>/bin/ispc
    -DEMBREE_GEOMETRY_HAIR:BOOL=OFF
    -DEMBREE_GEOMETRY_LINES:BOOL=OFF
    -DEMBREE_GEOMETRY_QUADS:BOOL=OFF
    -DEMBREE_GEOMETRY_SUBDIV:BOOL=OFF
    -DEMBREE_TUTORIALS:BOOL=OFF
    -DCMAKE_INSTALL_LIBDIR:STRING=lib)

superbuild_apply_patch(embree improve-findtbb
  "Improve FindTBB")
superbuild_apply_patch(embree fix-cray
  "Fix compilation under Cray Wrapper")
