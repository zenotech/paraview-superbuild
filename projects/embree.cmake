set(embree_BUILD_ISA "DEFAULT" CACHE STRING "ISAs to build Embree for")
mark_as_advanced(embree_BUILD_ISA)
set(embree_isa_args)
if(NOT (embree_BUILD_ISA STREQUAL "DEFAULT"))
  if(embree_BUILD_ISA STREQUAL "ALL")
    set(embree_BUILD_ISA SSE2 SSE42 AVX AVX2 AVX512KNL AVX512SKX)
  endif()
  list(APPEND embree_isa_args -DEMBREE_MAX_ISA:BOOL=NONE)
  foreach(isa IN LISTS embree_BUILD_ISA)
    list(APPEND embree_isa_args -DEMBREE_ISA_${isa}:BOOL=ON)
  endforeach()
endif()

superbuild_add_project(embree
  DEPENDS ispc tbb cxx11
  CMAKE_ARGS
    ${embree_isa_args}
    -DEMBREE_ISPC_EXECUTABLE:PATH=<INSTALL_DIR>/bin/ispc
    -DEMBREE_GEOMETRY_HAIR:BOOL=OFF
    -DEMBREE_GEOMETRY_LINES:BOOL=OFF
    -DEMBREE_GEOMETRY_QUADS:BOOL=OFF
    -DEMBREE_GEOMETRY_SUBDIV:BOOL=OFF
    -DEMBREE_TUTORIALS:BOOL=OFF
    -DCMAKE_INSTALL_LIBDIR:STRING=lib)

superbuild_apply_patch(embree improve-findtbb
  "Improve FindTBB")
superbuild_apply_patch(embree rename-options-file
  "Rename compiler options file")
superbuild_apply_patch(embree craype-include
  "Let CrayPE include other compiler options")
superbuild_apply_patch(embree move-sse2-flags
  "Move FLAGS_SSE2 out of CMAKE_CXX_FLAGS")
