foreach (executable IN LISTS paraview_executables)
  superbuild_unix_install_program("${executable}"
    "paraview-${paraview_version}")
endforeach ()

foreach (paraview_plugin IN LISTS paraview_plugins)
  superbuild_unix_install_plugin("lib${paraview_plugin}.so"
    "paraview-${paraview_version}"
    ";paraview-${paraview_version}"
    "paraview-${paraview_version}/plugins/")
endforeach ()

set(plugins_file "${CMAKE_CURRENT_BINARY_DIR}/paraview.plugins")
paraview_add_plugin("${plugins_file}" ${paraview_plugins})

install(
  FILES       "${plugins_file}"
  DESTINATION "lib/paraview-${paraview_version}"
  COMPONENT   superbuild
  RENAME      ".plugins")

if (MESA_SWR_ENABLED AND
    (osmesa_built_by_superbuild OR mesa_built_by_superbuild))
  # FIXME(package): install using the install macros.
  install(
    FILES       "${superbuild_install_location}/lib/libswrAVX.so"
                "${superbuild_install_location}/lib/libswrAVX2.so"
    DESTINATION lib
    COMPONENT   superbuild)
endif ()

if (python_enabled)
  include(python.functions)
  superbuild_install_superbuild_python()

  superbuild_unix_install_python(
    "${CMAKE_INSTALL_PREFIX}"
    "paraview-${paraview_version}"
    MODULES paraview
            vtk
            ${python_modules}
    MODULE_DIRECTORIES
            "${superbuild_install_location}/lib/python2.7/site-packages"
            "${superbuild_install_location}/lib/paraview-${paraview_version}/site-packages"
    SEARCH_DIRECTORIES
            "paraview-${paraview_version}")

  superbuild_unix_install_python(
    "${CMAKE_INSTALL_PREFIX}"
    "paraview-${paraview_version}"
    MODULES   vtk
    NAMESPACE paraview
    MODULE_DIRECTORIES
            "${superbuild_install_location}/lib/python2.7/site-packages"
            "${superbuild_install_location}/lib/paraview-${paraview_version}/site-packages"
    SEARCH_DIRECTORIES
            "paraview-${paraview_version}")

  if (matplotlib_enabled)
    install(
      DIRECTORY   "${superbuild_install_location}/lib/python2.7/site-packages/matplotlib/mpl-data/"
      DESTINATION "lib/python2.7/site-packages/matplotlib/mpl-data"
      COMPONENT   superbuild)
  endif ()
endif ()

if (mpi_built_by_superbuild)
  set(mpi_executables
    hydra_nameserver
    hydra_persist
    hydra_pmi_proxy
    mpiexec
    mpiexec.hydra)
  foreach (mpi_executable IN LISTS mpi_executables)
    superbuild_unix_install_utility("${mpi_executable}"
      "paraview-${paraview_version}"
      "../bin")
  endforeach ()
endif ()
