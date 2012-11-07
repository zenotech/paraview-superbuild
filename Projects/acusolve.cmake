

add_external_project(acusolve
  DEPENDS paraview

  CMAKE_ARGS
    -DParaView_DIR:PATH=${SuperBuild_BINARY_DIR}/paraview/src/paraview-build

  INSTALL_COMMAND
    ${CMAKE_COMMAND} -E tar cfz
      ${CMAKE_CURRENT_BINARY_DIR}/AcuSolveReaderPlugin-${package_suffix}.tgz
      <BINARY_DIR>/${CMAKE_SHARED_LIBRARY_PREFIX}AcuSolveReader${CMAKE_SHARED_LIBRARY_SUFFIX}
)
