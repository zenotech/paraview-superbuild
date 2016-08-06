set(OSPRAY_BUILD_ISA "AVX"
  CACHE STRING "Target ISA for OSPray (SSE, AVX, AVX2 or ALL).")
mark_as_advanced(OSPRAY_BUILD_ISA)
set_property(CACHE OSPRAY_BUILD_ISA
  PROPERTY
    STRINGS SSE AVX AVX2 ALL)

superbuild_add_project(ospray
  DEPENDS ispc tbb cxx11
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
    -DCMAKE_INSTALL_LIBDIR:STRING=lib)

if (WIN32)
  if (superbuild_build_phase)
    set(ospray_source_dir "<SOURCE_DIR>")
    _ep_replace_location_tags(ospray ospray_source_dir)

    # The installed ospray.config isn't quite right on Windows.
    superbuild_add_extra_cmake_args(
      -DOSPRAY_BUILD_DIR:PATH=${ospray_binary_dir})
  endif ()
else ()
  superbuild_add_extra_cmake_args(
    -DOSPRAY_INSTALL_DIR:PATH=<INSTALL_DIR>)
endif ()
