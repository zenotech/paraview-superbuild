## Builds qhull from git://gitorious.org/qhull/qhull.git
add_external_project(
    qhull
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>/qhull
    INSTALL_COMMAND make install
)
