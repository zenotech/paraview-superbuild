include(paraview-version)

set(paraview_doc_dir "share/paraview-${paraview_version}/doc")
set(paraview_data_dir "share/paraview-${paraview_version}/examples")
set(paraview_materials_dir "share/paraview-${paraview_version}/materials")
set(paraview_plugin_path "lib/paraview-${paraview_version}/plugins")
include(paraview.bundle.common)

set(paraview_component ParaView)
include(paraview.bundle.unix)

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

if (paraviewweb_enabled)
  install(
    DIRECTORY   "${superbuild_install_location}/share/paraview/web"
    DESTINATION "share/paraview-${paraview_version}"
    COMPONENT   "${paraview_component}")
endif ()
