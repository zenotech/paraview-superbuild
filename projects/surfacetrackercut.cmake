superbuild_add_project(surfacetrackercut
  LICENSE_FILES
    LICENSE
  DEPENDS paraview lapack
  DEPENDS_OPTIONAL qt5
  SOURCE_SUBDIR SurfaceTrackerCut
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_INSTALL_LIBDIR:PATH=lib)
