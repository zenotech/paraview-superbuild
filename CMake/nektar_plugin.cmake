add_external_project(nektar_plugin
  DEPENDS paraview

  CMAKE_ARGS
    -DParaView_DIR:PATH=${ParaViewSuperBuild_BINARY_DIR}/paraview/src/paraview-build
    -DBLAS_atlas_LIBRARY:FILEPATH=/soft/apps/atlas-3.8.2-gcc-shared/lib/libatlas.a
    -DBLAS_f77blas_LIBRARY:FILEPATH=/soft/apps/atlas-3.8.2-gcc-shared/lib/libf77blas.a
    -DLAPACK_lapack_LIBRARY:FILEPATH=/soft/apps/atlas-3.8.2-gcc-shared/lib/liblapack.a

  INSTALL_COMMAND
    ${CMAKE_COMMAND} -E tar cfz
      ${CMAKE_CURRENT_BINARY_DIR}/NektarReaderPlugin-${package_suffix}.tgz
      <BINARY_DIR>/libpvNektarReader.so
)
