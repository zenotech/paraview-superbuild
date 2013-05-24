add_external_project(cosmologytools
    DEPENDS diy qhull paraview

    CMAKE_ARGS
        -DBUILD_PV_PLUGINS:BOOL=ON
        -DBUILD_SHARED_LIBS:BOOL=OFF
        -DParaView_DIR:PATH=${ParaViewSuperBuild_BINARY_DIR}/paraview/src/paraview-build
        -DDIY_INCLUDE_DIRS:PATH=${ParaViewSuperBuild_BINARY_DIR}/diy/src/diy/include
        -DDIY_LIBRARIES:PATH=${ParaViewSuperBuild_BINARY_DIR}/diy/src/diy/lib/libdiy.a
        -DQHULL_INCLUDE_DIRS:PATH=${ParaViewSuperBuild_BINARY_DIR}/qhull/src/qhull/src/libqhull
        -DQHULL_LIBRARIES:PATH=${ParaViewSuperBuild_BINARY_DIR}/qhull/src/qhull-build/libqhullstatic.a

    INSTALL_COMMAND
        ${CMAKE_COMMAND} -DBINARY_DIR:PATH=<BINARY_DIR>
                         -DINSTALL_DIR:PATH=<INSTALL_DIR>
                         -DPARAVIEW_BINARY_DIR:PATH=${ParaViewSuperBuild_BINARY_DIR}/paraview/src/paraview-build
                         -DTMP_DIR:PATH=<TMP_DIR>
                         -Dbundle_name:STRING=${CMAKE_CURRENT_BINARY_DIR}/CosmologyToolsPlugin
                         -Dbundle_suffix:STRING=${pv_version_long}-${package_suffix}
                         -P ${CMAKE_CURRENT_LIST_DIR}/install_cosmologytools.cmake
)
