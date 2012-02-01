if (64bit_build)
  set (bundle_name "AcuSolveReaderPlugin-${platform_label}-64bit.tgz")
else()
  set (bundle_name "AcuSolveReaderPlugin-${platform_label}-32bit.tgz")
endif()

add_external_project(acusolve_plugin
  DEPENDS paraview

  CMAKE_ARGS
    -DParaView_DIR:PATH=${ParaViewSuperBuild_BINARY_DIR}/paraview/src/paraview-build

  INSTALL_COMMAND
    ${CMAKE_COMMAND} -E tar cfz ${CMAKE_CURRENT_BINARY_DIR}/${bundle_name}
                    <BINARY_DIR>/libAcuSolveReader.so
)
