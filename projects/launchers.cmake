superbuild_add_project(launchers
  DEPENDS paraview
  DEPENDS_OPTIONAL mesa osmesa mpi qt5

  CMAKE_ARGS
    -DCMAKE_INSTALL_BINDIR:PATH=bin
    -DCMAKE_INSTALL_LIBDIR:PATH=lib
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DLAUNCHER_ENABLE_MESA:BOOL=${mesa_enabled}
    -DLAUNCHER_ENABLE_OSMESA:BOOL=${osmesa_enabled}
    -DLAUNCHER_MESA_HAS_SWR:BOOL=${mesa_USE_SWR}
    -DLAUNCHER_MESA_LIBDIR:STRING=<LIBDIR>/mesa
    -DLAUNCHER_ENABLE_MPI:BOOL=${mpi_enabled}
    -DLAUNCHER_MPI_LIBDIR:STRING=<LIBDIR>/mpi
)
