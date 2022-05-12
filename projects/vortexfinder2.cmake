superbuild_add_project(vortexfinder2
  DEPENDS paraview
  # Note: lookingglass shouldnt' be needed when the remote module is added to VTK
  DEPENDS_OPTIONAL qt5 lookingglass
  LICENSE_FILES
    COPYING.md
  CMAKE_ARGS
    -DWITH_PARAVIEW:BOOL=ON
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_MACOSX_RPATH:BOOL=FALSE
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DPARAVIEW_DO_UNIX_STYLE_INSTALL:BOOL=ON
    -DWITH_MACOS_RPATH:BOOL=FALSE)

if (APPLE)
  # On Apple, only libc++ has the <tuple> header in older SDKs. For the use of
  # libc++.
  superbuild_append_flags(cxx_flags -stdlib=libc++ PROJECT_ONLY)
endif ()
