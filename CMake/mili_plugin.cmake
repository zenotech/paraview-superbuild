add_external_project(mili_plugin
  DEPENDS paraview
  CMAKE_ARGS
    -DParaView_DIR:PATH=${ParaViewSuperBuild_BINARY_DIR}/paraview/src/paraview-build
)
