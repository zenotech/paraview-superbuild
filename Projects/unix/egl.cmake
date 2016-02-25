option (ENABLE_egl "Build with EGL offscreen libraries" OFF)

if(ENABLE_egl)
  find_package(EGL REQUIRED)

  set(egl_ARGS
    -DEGL_INCLUDE_DIR:PATH=${EGL_INCLUDE_DIR}
    -DEGL_gldispatch_LIBRARY:FILEPATH=${EGL_gldispatch_LIBRARY}
    -DEGL_LIBRARY:FILEPATH=${EGL_LIBRARY}
    -DVTK_USE_OFFSCREEN_EGL:BOOL=ON
    -DVTK_USE_OFFSCREEN:BOOL=OFF
    -DVTK_USE_X:BOOL=OFF
    )

endif(ENABLE_egl)
