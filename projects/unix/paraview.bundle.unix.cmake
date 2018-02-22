set(library_paths
  "${superbuild_install_location}/lib")

if (Qt5_DIR)
  list(APPEND library_paths
    "${Qt5_DIR}/../..")
endif ()

set(include_regexes)
if (fortran_enabled)
  list(APPEND include_regexes
    ".*/libgfortran"
    ".*/libquadmath")
endif ()

set(exclude_regexes)
if (PARAVIEW_DEFAULT_SYSTEM_GL OR
    (mesa_built_by_superbuild OR osmesa_built_by_superbuild))
  list(APPEND exclude_regexes
    ".*/libglapi"
    ".*/libGL")
endif ()

foreach (executable IN LISTS paraview_executables)
  superbuild_unix_install_program_fwd("${executable}"
    "lib"
    SEARCH_DIRECTORIES  "${library_paths}"
    INCLUDE_REGEXES     ${include_regexes}
    EXCLUDE_REGEXES     ${exclude_regexes})
endforeach ()

foreach (paraview_plugin IN LISTS paraview_plugins)
  superbuild_unix_install_plugin("lib${paraview_plugin}.so"
    "lib"
    "${paraview_plugin_path}/${paraview_plugin}"
    LOADER_PATHS    "${library_paths}"
    INCLUDE_REGEXES ${include_regexes}
    EXCLUDE_REGEXES ${exclude_regexes}
    LOCATION        "${paraview_plugin_path}/${paraview_plugin}/")
endforeach ()

set(plugins_file "${CMAKE_CURRENT_BINARY_DIR}/paraview.plugins")
paraview_add_plugin("${plugins_file}" ${paraview_plugins})

install(
  FILES       "${plugins_file}"
  DESTINATION ${paraview_plugin_path}
  COMPONENT   superbuild
  RENAME      ".plugins")

if (mesa_libraries)
  set(suffix)
  if (PARAVIEW_DEFAULT_SYSTEM_GL)
    set(suffix "/mesa")
  endif ()

  foreach (mesa_library IN LISTS mesa_libraries)
    file(GLOB lib_filenames
      RELATIVE "${superbuild_install_location}/lib"
      "${superbuild_install_location}/lib/lib${mesa_library}.so*")

    foreach (lib_filename IN LISTS lib_filenames)
      superbuild_unix_install_plugin("${lib_filename}"
        "lib${suffix}"
        "lib"
        LOADER_PATHS  "${library_paths}"
        LOCATION      "lib${suffix}")
    endforeach ()
  endforeach ()
endif ()

if (nvidiaindex_enabled)
  set(nvidiaindex_libraries
    dice
    nvindex
    nvrtc-builtins)

  foreach (nvidiaindex_library IN LISTS nvidiaindex_libraries)
    file(GLOB lib_filenames
      RELATIVE "${superbuild_install_location}/lib"
      "${superbuild_install_location}/lib/lib${nvidiaindex_library}.so*")

    foreach (lib_filename IN LISTS lib_filenames)
      superbuild_unix_install_plugin("${lib_filename}"
        "lib"
        "lib"
        LOADER_PATHS  "${library_paths}"
        LOCATION      "lib"
        EXCLUDE_REGEXES ".*/libcuda.so.*")
    endforeach ()
  endforeach ()
endif ()

if (python_enabled)
  include(python.functions)
  superbuild_install_superbuild_python(
    LIBSUFFIX "/python2.7")

  superbuild_unix_install_python(
    LIBDIR              "lib"
    MODULES             paraview
                        vtk
                        vtkmodules
                        ${python_modules}
    INCLUDE_REGEXES     ${include_regexes}
    EXCLUDE_REGEXES     ${exclude_regexes}
    MODULE_DIRECTORIES  "${superbuild_install_location}/lib/python2.7/site-packages"
    LOADER_PATHS        "${library_paths}")

  if (matplotlib_built_by_superbuild)
    install(
      DIRECTORY   "${superbuild_install_location}/lib/python2.7/site-packages/matplotlib/mpl-data/"
      DESTINATION "lib/python2.7/site-packages/matplotlib/mpl-data"
      COMPONENT   superbuild)
  endif ()
endif ()

if (mpi_built_by_superbuild)
  set(mpi_executables_standalone
    mpiexec
    hydra_pmi_proxy)
  set(mpi_executables_paraview
    hydra_nameserver
    hydra_persist)
  foreach (mpi_executable IN LISTS mpi_executables_standalone)
    superbuild_unix_install_plugin("${superbuild_install_location}/bin/${mpi_executable}"
      "lib"
      "bin")
  endforeach ()
  foreach (mpi_executable IN LISTS mpi_executables_standalone mpi_executables_paraview)
    superbuild_unix_install_plugin("${superbuild_install_location}/bin/${mpi_executable}"
      "lib"
      "lib")
  endforeach ()
endif ()

if (qt5_enabled)
  file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/qt.conf" "")
  install(
    FILES       "${CMAKE_CURRENT_BINARY_DIR}/qt.conf"
    DESTINATION "lib"
    COMPONENT   superbuild)
endif ()

foreach (qt5_plugin_path IN LISTS qt5_plugin_paths)
  get_filename_component(qt5_plugin_group "${qt5_plugin_path}" DIRECTORY)
  get_filename_component(qt5_plugin_group "${qt5_plugin_group}" NAME)

  superbuild_unix_install_plugin("${qt5_plugin_path}"
    "lib"
    "lib/plugins/${qt5_plugin_group}/"
    LOADER_PATHS    "${library_paths}"
    INCLUDE_REGEXES ${include_regexes}
    EXCLUDE_REGEXES ${exclude_regexes})
endforeach ()

paraview_install_extra_data()
