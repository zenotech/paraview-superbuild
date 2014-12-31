add_external_project(
  cgns
  DEPENDS zlib hdf5

  PATCH_COMMAND
    # this patch fixes following issues:
    # 1. incorrect target links when HDF5 support is enabeld
    # 2. incorrect install rules on windows (and cleans up install rules on other
    #    platforms too).
    ${CMAKE_COMMAND} -E copy_if_different ${SuperBuild_PROJECTS_DIR}/patches/cgns.src.CMakeLists.txt
	                                        <SOURCE_DIR>/src/CMakeLists.txt
  CMAKE_ARGS
  -DCGNS_BUILD_SHARED:BOOL=${BUILD_SHARED_LIBS}
  -DENABLE_64BIT:BOOL=ON
  -DENABLE_HDF5:BOOL=ON
  -DHDF5_NEED_SZIP:BOOL=ON
  -DHDF5_NEED_ZLIB:BOOL=ON
)

if (WIN32)
  # This patch fixes the unnecessary installation rule for the cgns.dll which was incorrect
  # anyways when using MSVC (since the path didn't consider build configuration).
  add_external_project_step(patch1
    COMMENT "Fixing Windows install rules for CGNS tools"
	  COMMAND ${CMAKE_COMMAND} -E copy_if_different ${SuperBuild_PROJECTS_DIR}/patches/cgns.src.tools.CMakeLists.txt
	          <SOURCE_DIR>/src/tools/CMakeLists.txt
	  DEPENDEES update
    DEPENDERS patch)
endif()
