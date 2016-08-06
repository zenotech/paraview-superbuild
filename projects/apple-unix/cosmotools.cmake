if (BUILD_SHARED_LIBS)
  set(cosmotools_lib_suffix ${CMAKE_SHARED_LIBRARY_SUFFIX})
else ()
  set(cosmotools_lib_suffix ${CMAKE_STATIC_LIBRARY_SUFFIX})
endif ()

if (superbuild_build_phase)
  set(diy_include_dir "<SOURCE_DIR>/include")
  set(diy_library "<SOURCE_DIR>/lib/libdiy.a")
  _ep_replace_location_tags(diy diy_include_dir)
  _ep_replace_location_tags(diy diy_library)
endif ()

if (superbuild_build_phase)
  set(qhull_include_dir "<SOURCE_DIR>/src/libqhull")
  set(qhull_library "<BINARY_DIR>/libqhullstatic.a")
  _ep_replace_location_tags(qhull qhull_include_dir)
  _ep_replace_location_tags(qhull qhull_library)
endif ()

superbuild_add_project(cosmotools
  DEPENDS genericio diy qhull

  CMAKE_ARGS
    -DENABLE_DIY:BOOL=ON
    -DENABLE_QHULL:BOOL=ON
    -DBUILD_COSMOTOOLS_PROGRAMS:BOOL=OFF
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_SIMULATION_INTERFACE:BOOL=OFF
    -DBUILD_SINGLE_LIBRARY:BOOL=ON
    -DTYPE_IDS_64BITS:BOOL=ON
    -DDIY_INCLUDE_DIRS:PATH=${diy_include_dir}
    -DDIY_LIBRARIES:PATH=${diy_library}
    -DQHULL_INCLUDE_DIRS:PATH=${qhull_include_dir}
    -DQHULL_LIBRARIES:PATH=${qhull_library}

  INSTALL_COMMAND
    ${CMAKE_COMMAND} -E copy
      <BINARY_DIR>/libs/libcosmotools${lib_suffix}
      <INSTALL_DIR>/lib)

if (superbuild_build_phase)
  set(cosmotools_include_dir "<BINARY_DIR>/include")
  _ep_replace_location_tags(cosmotools cosmotools_include_dir)

  superbuild_add_extra_cmake_args(
    -DCOSMOTOOLS_INCLUDE_DIR:PATH=${cosmotools_include_dir}
    -DCOSMOTOOLS_LIBRARIES:PATH=<INSTALL_DIR>/libcosmotools${lib_suffix})
endif ()
