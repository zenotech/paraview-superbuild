add_external_project(paraview
  DEPENDS_OPTIONAL
    python

  BUILD_COMMAND
    make pvCompileTools

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS=1
    -DPARAVIEW_USE_MPI=0
    -DBUILD_TESTING=0
    -DPARAVIEW_BUILD_QT_GUI=0

  INSTALL_COMMAND
    echo "Skipping install"
)

conditionally_patch_for_crosscompilation(ParaViewTools)
