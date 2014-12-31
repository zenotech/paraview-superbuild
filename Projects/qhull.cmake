## Builds qhull from git://gitorious.org/qhull/qhull.git
add_external_project(
    qhull
    CMAKE_ARGS
        -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>/qhull
    INSTALL_COMMAND make install
)
