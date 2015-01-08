add_external_project(acusolve
  DEPENDS paraview

  CMAKE_ARGS
    -DParaView_DIR:PATH=${SuperBuild_BINARY_DIR}/paraview/src/paraview-build

  INSTALL_COMMAND
    ${CMAKE_COMMAND} -DBINARY_DIR:PATH=<BINARY_DIR>
                     -DINSTALL_DIR:PATH=<INSTALL_DIR>
                     -DPARAVIEW_BINARY_DIR:PATH=${ParaViewSuperBuild_BINARY_DIR}/paraview/src/paraview-build
                     -DTMP_DIR:PATH=<TMP_DIR>
                    "-DPLUGIN_SCRIPT:FILEPATH=${CMAKE_CURRENT_LIST_DIR}/plugin-macros.cmake"
                    "-D7Z_EXE:FILEPATH=${7Z_EXE}"
                     -Dbundle_name:STRING=${CMAKE_CURRENT_BINARY_DIR}/AcuSolveReaderPlugin
                     -Dbundle_suffix:STRING=${pv_version_long}-${package_suffix}
                     -P ${CMAKE_CURRENT_LIST_DIR}/install_acusolve.cmake
)
