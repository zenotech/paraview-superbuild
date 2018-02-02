set(paraview_doc_dir "doc")
set(paraview_data_dir "data")
set(paraview_plugin_path "bin/plugins")
include(paraview.bundle.common)

# Set NSIS install specific stuff.
if (CMAKE_CL_64)
  # Change default installation root path for Windows x64.
  set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
endif ()

# URL to website providing assistance in installing your application.
set(CPACK_NSIS_HELP_LINK "http://paraview.org/Wiki/ParaView")
set(paraview_description "ParaView ${paraview_version_full}")
set(pvserver_description "pvserver ${paraview_version_full} (Server)")
set(pvdataserver_description "pvdataserver ${paraview_version_full} (Data-Server)")
set(pvrenderserver_description "pvrenderserver ${paraview_version_full} (Render-Server)")
set(pvpython_description "pvpython ${paraview_version_full} (Python Shell)")

#FIXME: need a pretty icon.
#set(CPACK_NSIS_MUI_ICON "${CMAKE_CURRENT_LIST_DIR}/paraview.ico")
#set(CPACK_NSIS_MUI_FINISHPAGE_RUN "bin/paraview.exe")

set(library_paths "lib")

if (Qt5_DIR)
  list(APPEND library_paths
    "${Qt5_DIR}/../../../bin")
endif ()

# Install paraview executables to bin.
foreach (executable IN LISTS paraview_executables)
  if (DEFINED "${executable}_description")
    list(APPEND CPACK_NSIS_MENU_LINKS
      "bin/${executable}.exe" "${${executable}_description}")
  endif ()

  superbuild_windows_install_program("${executable}" "bin" SEARCH_DIRECTORIES
    "${library_paths}")
endforeach()

foreach (paraview_plugin IN LISTS paraview_plugins)
  superbuild_windows_install_plugin("${paraview_plugin}.dll"
    "${paraview_plugin_path}/${paraview_plugin}" "bin/plugins/${paraview_plugin}" SEARCH_DIRECTORIES
    "${paraview_plugin_path}/${paraview_plugin}" "${library_paths}" "${superbuild_install_location}/bin")
endforeach ()

set(plugins_file "${CMAKE_CURRENT_BINARY_DIR}/paraview.plugins")
paraview_add_plugin("${plugins_file}" ${paraview_plugins})

install(
  FILES       "${plugins_file}"
  DESTINATION "${paraview_plugin_path}"
  COMPONENT   superbuild
  RENAME      ".plugins")

if (python_enabled)
  include(python.functions)
  superbuild_install_superbuild_python()

  superbuild_windows_install_python(
    MODULES paraview
            vtk
            vtkmodules
            ${python_modules}
    MODULE_DIRECTORIES  "${superbuild_install_location}/bin/Lib/site-packages"
                        "${superbuild_install_location}/lib/site-packages"
                        "${superbuild_install_location}/lib/python2.7/site-packages"
                        "${superbuild_install_location}/lib/paraview-${paraview_version_major}.${paraview_version_minor}/site-packages"
    SEARCH_DIRECTORIES  "lib" "${superbuild_install_location}/bin")

  if (matplotlib_enabled)
    install(
      DIRECTORY   "${superbuild_install_location}/bin/Lib/site-packages/matplotlib/mpl-data/"
      DESTINATION "bin/Lib/site-packages/matplotlib/mpl-data"
      COMPONENT   superbuild)
  endif ()

  superbuild_windows_install_python(
    MODULES vtk
    NAMESPACE "/paraview"
    MODULE_DIRECTORIES
            "${superbuild_install_location}/bin/Lib/site-packages"
            "${superbuild_install_location}/lib/site-packages"
            "${superbuild_install_location}/lib/python2.7/site-packages"
            "${superbuild_install_location}/lib/paraview-${paraview_version_major}.${paraview_version_minor}/site-packages"
    SEARCH_DIRECTORIES  "lib" "${superbuild_install_location}/bin")
endif ()

if (paraviewweb_enabled)
  install(
    DIRECTORY   "${superbuild_install_location}/bin/Lib/site-packages/win32"
    DESTINATION "bin/Lib/site-packages"
    COMPONENT   "superbuild")
  install(
    FILES       "${superbuild_install_location}/bin/Lib/site-packages/pywin32.pth"
                "${superbuild_install_location}/bin/Lib/site-packages/pywin32.version.txt"
    DESTINATION "bin/Lib/site-packages"
    COMPONENT   "superbuild")
endif ()

foreach (qt5_plugin_path IN LISTS qt5_plugin_paths)
  get_filename_component(qt5_plugin_group "${qt5_plugin_path}" DIRECTORY)
  get_filename_component(qt5_plugin_group "${qt5_plugin_group}" NAME)

  superbuild_windows_install_plugin(
    "${qt5_plugin_path}"
    "bin"
    "bin/${qt5_plugin_group}"
    SEARCH_DIRECTORIES "${library_paths}")
endforeach ()

if (qt5_enabled)
  foreach (qt5_opengl_lib IN ITEMS opengl32sw libEGL libGLESv2)
    superbuild_windows_install_plugin(
      "${Qt5_DIR}/../../../bin/${qt5_opengl_lib}.dll"
      "bin"
      "bin"
      SEARCH_DIRECTORIES "${library_paths}")
  endforeach ()
endif ()

paraview_install_extra_data()
