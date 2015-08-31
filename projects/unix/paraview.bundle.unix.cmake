foreach (executable IN LISTS paraview_executables)
  superbuild_unix_install_program("${executable}"
    "paraview-${paraview_version}")
endforeach ()

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

  if (matplotlib_enabled)
    install(
      DIRECTORY   "${superbuild_install_location}/lib/python2.7/site-packages/matplotlib/mpl-data/"
      DESTINATION "lib/python2.7/site-packages/matplotlib/mpl-data"
      COMPONENT   superbuild)
  endif ()
endif ()

if (mpi_enabled AND NOT USE_SYSTEM_mpi)
  set(mpi_executables
    hydra_nameserver
    hydra_persist
    hydra_pmi_proxy
    mpiexec)
  foreach (mpi_executable IN LISTS mpi_executables)
    superbuild_unix_install_utility("${mpi_executable}"
      "paraview-${paraview_version}"
      "../bin")
  endforeach ()
endif ()
