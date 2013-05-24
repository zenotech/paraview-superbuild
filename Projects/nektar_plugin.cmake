add_external_project(nektar_plugin
  DEPENDS paraview

  CMAKE_ARGS
    -DParaView_DIR:PATH=${SuperBuild_BINARY_DIR}/paraview/src/paraview-build
    -DBLAS_atlas_LIBRARY:FILEPATH=/soft/apps/atlas-3.8.2-gcc-shared/lib/libatlas.a
    -DBLAS_f77blas_LIBRARY:FILEPATH=/soft/apps/atlas-3.8.2-gcc-shared/lib/libf77blas.a
    -DLAPACK_lapack_LIBRARY:FILEPATH=/soft/apps/atlas-3.8.2-gcc-shared/lib/liblapack.a

  INSTALL_COMMAND
    ${CMAKE_COMMAND} -DBINARY_DIR:PATH=<BINARY_DIR>
                     -DINSTALL_DIR:PATH=<INSTALL_DIR>
                     -DPARAVIEW_BINARY_DIR:PATH=${ParaViewSuperBuild_BINARY_DIR}/paraview/src/paraview-build
                     -DTMP_DIR:PATH=<TMP_DIR>
                     -Dbundle_name:STRING=${CMAKE_CURRENT_BINARY_DIR}/NektarReaderPlugin
                     -Dbundle_suffix:STRING=${pv_version_long}-${package_suffix}
                     -P ${CMAKE_CURRENT_LIST_DIR}/install_nektar_plugin.cmake
)
