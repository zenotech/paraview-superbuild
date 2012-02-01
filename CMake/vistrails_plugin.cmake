add_external_project(vistrails_plugin
  DEPENDS paraview boost

  CMAKE_ARGS
    -DParaView_DIR:PATH=${ParaViewSuperBuild_BINARY_DIR}/paraview/src/paraview-build
)
