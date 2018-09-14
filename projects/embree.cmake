set(embree_BUILD_ISA "DEFAULT" CACHE STRING "ISAs to build Embree for")
mark_as_advanced(embree_BUILD_ISA)
set(embree_isa_args)
set(embree_allow_skx "-DEMBREE_ISA_AVX512SKX:BOOL=OFF") #default off due to flaky trycompile
if(NOT (embree_BUILD_ISA STREQUAL "DEFAULT"))
  if(embree_BUILD_ISA STREQUAL "ALL")
    set(embree_BUILD_ISA SSE2 SSE42 AVX AVX2 AVX512KNL AVX512SKX)
  endif()
  list(APPEND embree_isa_args -DEMBREE_MAX_ISA:BOOL=NONE)
  foreach(isa IN LISTS embree_BUILD_ISA)
    list(APPEND embree_isa_args -DEMBREE_ISA_${isa}:BOOL=ON)
    if (isa MATCHES "AVX512SKX")
      set(embree_allow_skx)
    endif()
  endforeach()
endif()

superbuild_add_project(embree
  DEPENDS ispc tbb cxx11
  CMAKE_ARGS
    ${embree_isa_args}
    ${embree_allow_skx}
    -DBUILD_TESTING:BOOL=OFF
    -DEMBREE_ISPC_EXECUTABLE:PATH=<INSTALL_DIR>/bin/ispc
    -DEMBREE_GEOMETRY_HAIR:BOOL=ON
    -DEMBREE_GEOMETRY_LINES:BOOL=OFF
    -DEMBREE_GEOMETRY_QUADS:BOOL=OFF
    -DEMBREE_GEOMETRY_SUBDIV:BOOL=OFF
    -DEMBREE_TUTORIALS:BOOL=OFF
    -DCMAKE_INSTALL_LIBDIR:STRING=lib)

if (MSVC_VERSION EQUAL 1900)
  superbuild_append_flags(cxx_flags "-d2SSAOptimizer-" PROJECT_ONLY)
endif()
