include(paraview-appname)
set(paraview_doc_dir "${paraview_appname}/Contents/doc")
set(paraview_data_dir "${paraview_appname}/Contents/examples")
set(paraview_materials_dir "${paraview_appname}/Contents/materials")
set(paraview_plugin_path "lib/paraview-${paraview_version}/plugins")
include(paraview.bundle.common)

if (NOT paraview_has_gui)
  message(FATAL_ERROR "Creating the Apple package without the GUI is not supported.")
endif ()

set(paraview_plugin_paths)
foreach (paraview_plugin IN LISTS paraview_plugins)
  if (EXISTS "${superbuild_install_location}/Applications/paraview.app/Contents/Plugins/lib${paraview_plugin}.dylib")
    list(APPEND paraview_plugin_paths
      "${superbuild_install_location}/Applications/paraview.app/Contents/Plugins/lib${paraview_plugin}.dylib")
    continue ()
  endif ()

  foreach (path IN ITEMS "" "paraview-${paraview_version}" "paraview-${paraview_version}/plugins/${paraview_plugin}")
    if (EXISTS "${superbuild_install_location}/lib/${path}/lib${paraview_plugin}.dylib")
      list(APPEND paraview_plugin_paths
        "${superbuild_install_location}/lib/${path}/lib${paraview_plugin}.dylib")
      break ()
    elseif (EXISTS "${superbuild_install_location}/lib/${path}/${paraview_plugin}.so")
      list(APPEND paraview_plugin_paths
        "${superbuild_install_location}/lib/${path}/${paraview_plugin}.so")
      break ()
    endif ()
  endforeach ()
endforeach ()

set(include_regexes)
if (fortran_enabled)
  list(APPEND include_regexes
    ".*/libgfortran"
    ".*/libquadmath")
endif ()

set(additional_libraries)
if (ospray_enabled)
  list(APPEND additional_libraries
    "${superbuild_install_location}/lib/libospray_module_ispc.dylib")
endif ()

superbuild_apple_create_app(
  "\${CMAKE_INSTALL_PREFIX}"
  "${paraview_appname}"
  "${superbuild_install_location}/Applications/paraview.app/Contents/MacOS/paraview"
  CLEAN
  PLUGINS ${paraview_plugin_paths}
  SEARCH_DIRECTORIES "${superbuild_install_location}/lib"
  ADDITIONAL_LIBRARIES ${additional_libraries}
  INCLUDE_REGEXES     ${include_regexes})

set(plugins_file "${CMAKE_CURRENT_BINARY_DIR}/paraview.plugins.xml")
paraview_add_plugin("${plugins_file}" ${paraview_plugins})

install(
  FILES       "${plugins_file}"
  DESTINATION "${paraview_appname}/Contents/Plugins"
  COMPONENT   superbuild)

if (EXISTS "${superbuild_install_location}/Applications/paraview.app/Contents/Resources/paraview.conf")
  file(READ "${superbuild_install_location}/Applications/paraview.app/Contents/Resources/paraview.conf" conf_contents)
  string(REGEX REPLACE "[^\n]*/" "../Plugins/" pkg_conf_contents "${conf_contents}")
  file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/paraview.conf" "${pkg_conf_contents}")
  install(
    FILES       "${CMAKE_CURRENT_BINARY_DIR}/paraview.conf"
    DESTINATION "${paraview_appname}/Contents/Resources/"
    COMPONENT   superbuild)
endif ()


install(
  FILES       "${superbuild_install_location}/Applications/paraview.app/Contents/Resources/pvIcon.icns"
  DESTINATION "${paraview_appname}/Contents/Resources"
  COMPONENT   superbuild)
install(
  FILES       "${superbuild_install_location}/Applications/paraview.app/Contents/Info.plist"
  DESTINATION "${paraview_appname}/Contents"
  COMPONENT   superbuild)

# Remove "paraview" from the list since we just installed it above.
list(REMOVE_ITEM paraview_executables
  paraview)

foreach (executable IN LISTS paraview_executables)
  superbuild_apple_install_utility(
    "\${CMAKE_INSTALL_PREFIX}"
    "${paraview_appname}"
    "${superbuild_install_location}/bin/${executable}"
    SEARCH_DIRECTORIES "${superbuild_install_location}/lib"
    INCLUDE_REGEXES     ${include_regexes})
endforeach ()

if (qt5_enabled)
  file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/qt.conf" "[Paths]\nPlugins = Plugins\n")
  install(
    FILES       "${CMAKE_CURRENT_BINARY_DIR}/qt.conf"
    DESTINATION "${paraview_appname}/Contents/Resources"
    COMPONENT   superbuild)
endif ()

if (python_enabled)
  file(GLOB egg_dirs
    "${superbuild_install_location}/lib/python${superbuild_python_version}/site-packages/*.egg/")
  superbuild_apple_install_python(
    "\${CMAKE_INSTALL_PREFIX}"
    "${paraview_appname}"
    MODULES paraview
            vtk
            vtkmodules
            ${python_modules}
    MODULE_DIRECTORIES
            "${superbuild_install_location}/Applications/paraview.app/Contents/Python"
            "${superbuild_install_location}/lib/python${superbuild_python_version}/site-packages"
            ${egg_dirs}
    SEARCH_DIRECTORIES
            "${superbuild_install_location}/Applications/paraview.app/Contents/Libraries"
            "${superbuild_install_location}/lib")

  if (matplotlib_enabled)
    install(
      DIRECTORY   "${superbuild_install_location}/lib/python${superbuild_python_version}/site-packages/matplotlib/mpl-data/"
      DESTINATION "${paraview_appname}/Contents/Python/matplotlib/mpl-data"
      COMPONENT   superbuild)
  endif ()
endif ()

if (mpi_built_by_superbuild)
  set(mpi_executables
    hydra_pmi_proxy
    mpiexec.hydra)

  foreach (mpi_executable IN LISTS mpi_executables)
    superbuild_apple_install_utility(
      "\${CMAKE_INSTALL_PREFIX}"
      "${paraview_appname}"
      "${superbuild_install_location}/bin/${mpi_executable}"
      SEARCH_DIRECTORIES "${superbuild_install_location}/lib"
      INCLUDE_REGEXES     ${include_regexes})
  endforeach ()

  install(CODE
    "foreach (mpi_executable IN ITEMS ${mpi_executables})
      configure_file(
        \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${paraview_appname}/Contents/bin/\${mpi_executable}\"
        \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${paraview_appname}/Contents/MacOS/\${mpi_executable}\"
        COPYONLY)
    endforeach ()
    file(RENAME
      \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${paraview_appname}/Contents/MacOS/mpiexec.hydra\"
      \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${paraview_appname}/Contents/MacOS/mpiexec\")
    file(RENAME
      \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${paraview_appname}/Contents/bin/mpiexec.hydra\"
      \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${paraview_appname}/Contents/bin/mpiexec\")"
    COMPONENT superbuild)
endif ()

# Configure ParaViewDMGSetup.scpt to replace the app name in the script.
configure_file(
  "${CMAKE_CURRENT_LIST_DIR}/files/ParaViewDMGSetup.scpt.in"
  "${CMAKE_CURRENT_BINARY_DIR}/ParaViewDMGSetup.scpt"
  @ONLY)

set(CPACK_DMG_BACKGROUND_IMAGE "${CMAKE_CURRENT_LIST_DIR}/files/ParaViewDMGBackground.tif")
set(CPACK_DMG_DS_STORE_SETUP_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/ParaViewDMGSetup.scpt")

if (paraviewweb_enabled)
  install(
    DIRECTORY   "${superbuild_install_location}/share/paraview/web"
    DESTINATION "${paraview_appname}/Contents/Resources"
    COMPONENT   "superbuild")
endif ()

foreach (qt5_plugin_path IN LISTS qt5_plugin_paths)
  get_filename_component(qt5_plugin_group "${qt5_plugin_path}" DIRECTORY)
  get_filename_component(qt5_plugin_group "${qt5_plugin_group}" NAME)

  superbuild_apple_install_module(
    "\${CMAKE_INSTALL_PREFIX}"
    "${paraview_appname}"
    "${qt5_plugin_path}"
    "Contents/Plugins/${qt5_plugin_group}"
    SEARCH_DIRECTORIES  "${library_paths}")
endforeach ()

paraview_install_extra_data()
