add_external_project(vistrails_plugin
  DEPENDS paraview boost

  CMAKE_ARGS
    -DParaView_DIR:PATH=${ParaViewSuperBuild_BINARY_DIR}/paraview/src/paraview-build

  INSTALL_COMMAND
    ${CMAKE_COMMAND} -DSOURCE_DIR:PATH=<SOURCE_DIR>
                     -DBINARY_DIR:PATH=<BINARY_DIR>
                     -DTMP_DIR:PATH=<TMP_DIR>
                     -Dbundle_name:STRING=${CMAKE_CURRENT_BINARY_DIR}/VisTrailsPlugin-${package_suffix}.tgz
                     -P ${CMAKE_CURRENT_LIST_DIR}/install_vistrails.cmake
)
