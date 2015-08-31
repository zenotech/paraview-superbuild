include(paraview-version)

set(paraview_doc_dir "share/paraview-${paraview_version}/doc")
set(paraview_data_dir "share/paraview-${paraview_version}/data")
include(paraview.bundle.common)

set(paraview_component ParaView)
include(paraview.bundle.unix)

# Other miscellaneous dependencies.
if ((qt4_enabled AND NOT USE_SYSTEM_qt4) OR (qt5_enabled AND NOT USE_SYSTEM_qt))
  # TODO: get a list of Qt plugins.
  foreach (qt_plugin IN LISTS qt_plugins)
    superbuild_unix_install_plugin("${qt_plugin}.so"
      "paraview-${paraview_version}"
      ";paraview-${paraview_version}"
      "paraview-${paraview_version}")
  endforeach ()
endif ()

if (paraview_has_gui)
  install(
    DIRECTORY   "${superbuild_install_location}/share/appdata"
    DESTINATION "share"
    COMPONENT   "${paraview_component}"
    USE_SOURCE_PERMISSIONS)
  install(
    DIRECTORY   "${superbuild_install_location}/share/applications"
    DESTINATION "share"
    COMPONENT   "${paraview_component}"
    USE_SOURCE_PERMISSIONS)
  install(
    DIRECTORY   "${superbuild_install_location}/share/icons"
    DESTINATION "share"
    COMPONENT   "${paraview_component}"
    USE_SOURCE_PERMISSIONS)
endif ()

# Add ParaViewWeb www directory if available.
if (python_enabled)
  install(
    DIRECTORY   "${superbuild_install_location}/share/paraview-${paraview_version}/www"
    DESTINATION "share/paraview-${paraview_version}"
    COMPONENT   "${paraview_component}"
    USE_SOURCE_PERMISSIONS)
endif ()
