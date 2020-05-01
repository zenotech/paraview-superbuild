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
if (launchers_enabled OR
    (mesa_built_by_superbuild OR osmesa_built_by_superbuild))
  list(APPEND exclude_regexes
    ".*/libglapi"
    ".*/libGL")
endif ()

if (launchers_enabled AND mpi_built_by_superbuild)
  list(APPEND exclude_regexes
    ".*/libmpi"
    ".*/libmpicxx")
endif()

foreach (executable IN LISTS paraview_executables)
  superbuild_unix_install_program("${superbuild_install_location}/bin/${executable}"
    "lib"
    SEARCH_DIRECTORIES  "${library_paths}"
    INCLUDE_REGEXES     ${include_regexes}
    EXCLUDE_REGEXES     ${exclude_regexes})

  if (launchers_enabled)
    superbuild_unix_install_program("${superbuild_install_location}/bin/${executable}-launcher"
      "lib"
      SEARCH_DIRECTORIES  "${library_paths}"
      INCLUDE_REGEXES     ${include_regexes}
      EXCLUDE_REGEXES     ${exclude_regexes})

    # rename executables.
    install(CODE "
       set(_prefix \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/bin\")
       file(RENAME \"\${_prefix}/${executable}\" \"\${_prefix}/${executable}-real\")
       file(RENAME \"\${_prefix}/${executable}-launcher\" \"\${_prefix}/${executable}\")"
      COMPONENT superbuild)
  endif()
endforeach ()

if (EXISTS "${superbuild_install_location}/bin/paraview.conf")
  install(
    FILES       "${superbuild_install_location}/bin/paraview.conf"
    DESTINATION "bin"
    COMPONENT   "runtime")
endif ()

foreach (paraview_plugin IN LISTS paraview_plugins)
  superbuild_unix_install_plugin("${paraview_plugin}.so"
    "lib"
    "${paraview_plugin_path}/${paraview_plugin}"
    LOADER_PATHS    "${library_paths}"
    INCLUDE_REGEXES ${include_regexes}
    EXCLUDE_REGEXES ${exclude_regexes}
    LOCATION        "${paraview_plugin_path}/${paraview_plugin}/")
endforeach ()

set(plugins_file "${CMAKE_CURRENT_BINARY_DIR}/paraview.plugins.xml")
paraview_add_plugin("${plugins_file}" ${paraview_plugins})

install(
  FILES       "${plugins_file}"
  DESTINATION ${paraview_plugin_path}
  COMPONENT   superbuild)

if (mesa_libraries)
  set(suffix)
  if (launchers_enabled)
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

if (launchers_enabled AND mpi_built_by_superbuild)
  set(mpi_libraries
    mpi
    mpicxx)
  set(suffix "/mpi")
  foreach (mpi_library IN LISTS mpi_libraries)
    file(GLOB lib_filenames
      RELATIVE "${superbuild_install_location}/lib"
      "${superbuild_install_location}/lib/lib${mpi_library}.so*")

    foreach (lib_filename IN LISTS lib_filenames)
      superbuild_unix_install_plugin("${lib_filename}"
        "lib${suffix}"
        "lib"
        LOADER_PATHS  "${library_paths}"
        LOCATION      "lib${suffix}")
    endforeach ()
  endforeach ()
endif()

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

if (ospray_enabled)
  set(osprayextra_libraries
    ospray_module_ispc)

  foreach (osprayextra_library IN LISTS osprayextra_libraries)
    file(GLOB lib_filenames
      RELATIVE "${superbuild_install_location}/lib"
      "${superbuild_install_location}/lib/lib${osprayextra_library}.so*")

    foreach (lib_filename IN LISTS lib_filenames)
      superbuild_unix_install_plugin("${lib_filename}"
        "lib"
        "lib"
        LOADER_PATHS  "${library_paths}"
        LOCATION      "lib")
    endforeach ()
  endforeach ()
endif ()

if (visrtx_enabled)
  set(visrtxextra_libraries
    libVisRTX
    dds
    nv_freeimage
    libmdl_sdk)

  foreach (visrtxextra_library IN LISTS visrtxextra_libraries)
    file(GLOB lib_filenames
      RELATIVE "${superbuild_install_location}/lib"
      "${superbuild_install_location}/lib/${visrtxextra_library}.so*")

    foreach (lib_filename IN LISTS lib_filenames)
      superbuild_unix_install_plugin("${lib_filename}"
        "lib"
        "lib"
        LOADER_PATHS  "${library_paths}"
        LOCATION      "lib"
        SEARCH_DIRECTORIES "/usr/lib64/libglvnd" "/usr/lib/libglvnd"
        EXCLUDE_REGEXES ".*/libGLX.so.*")
    endforeach ()
  endforeach ()
endif ()

if (python_enabled)
  file(GLOB egg_dirs
    "${superbuild_install_location}/lib/python${superbuild_python_version}/site-packages/*.egg/")
  if (python3_built_by_superbuild)
    include(python3.functions)
    superbuild_install_superbuild_python3(
      LIBSUFFIX "/python${superbuild_python_version}")
  endif ()

  # Add extra paths to MODULE_DIRECTORIES here (.../local/lib/python${superbuild_python_version}/dist-packages)
  # is a workaround to an issue when building against system python.  When we move to
  # Python3, we should make sure all the python modules get installed to the same
  # location to begin with.
  #
  # Related issue: https://gitlab.kitware.com/paraview/paraview-superbuild/issues/120
  superbuild_unix_install_python(
    LIBDIR              "lib"
    MODULES             ${python_modules}
    INCLUDE_REGEXES     ${include_regexes}
    EXCLUDE_REGEXES     ${exclude_regexes}
    MODULE_DIRECTORIES  "${superbuild_install_location}/lib/python${superbuild_python_version}/site-packages"
                        ${egg_dirs}
    LOADER_PATHS        "${library_paths}")

  if (matplotlib_built_by_superbuild)
    install(
      DIRECTORY   "${superbuild_install_location}/lib/python${superbuild_python_version}/site-packages/matplotlib/mpl-data/"
      DESTINATION "lib/python${superbuild_python_version}/site-packages/matplotlib/mpl-data"
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

if (qt5_enabled AND qt5_plugin_paths)
  file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/qt.conf" "[Paths]\nPrefix = ..\n")
  install(
    FILES       "${CMAKE_CURRENT_BINARY_DIR}/qt.conf"
    DESTINATION "bin"
    COMPONENT   superbuild)
endif ()

foreach (qt5_plugin_path IN LISTS qt5_plugin_paths)
  get_filename_component(qt5_plugin_group "${qt5_plugin_path}" DIRECTORY)
  get_filename_component(qt5_plugin_group "${qt5_plugin_group}" NAME)

  superbuild_unix_install_plugin("${qt5_plugin_path}"
    "lib"
    "plugins/${qt5_plugin_group}/"
    LOADER_PATHS    "${library_paths}"
    INCLUDE_REGEXES ${include_regexes}
    EXCLUDE_REGEXES ${exclude_regexes})
endforeach ()

paraview_install_extra_data()
