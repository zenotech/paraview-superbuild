add_external_project(acusolve_plugin
  DEPENDS paraview

  CMAKE_ARGS
    -DParaView_DIR:PATH=${SuperBuild_BINARY_DIR}/paraview/src/paraview-build

  INSTALL_COMMAND
    ${CMAKE_COMMAND} -E tar cfz
      ${CMAKE_CURRENT_BINARY_DIR}/AcuSolveReaderPlugin-${package_suffix}.tgz
      <BINARY_DIR>/libAcuSolveReader.so
)
