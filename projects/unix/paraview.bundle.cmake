include(paraview-version)

set(paraview_doc_dir "share/paraview-${paraview_version}/doc")
set(paraview_data_dir "share/paraview-${paraview_version}/data")
set(paraview_plugin_path "lib")
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
    FILES       "${superbuild_install_location}/lib/python2.7/site-packages/paraview/web/defaultProxies.json"
    DESTINATION "lib/python2.7/site-packages/paraview/web"
    COMPONENT   "${paraview_component}")
  install(
    DIRECTORY   "${superbuild_install_location}/share/paraview/web"
    DESTINATION "share/paraview-${paraview_version}"
    COMPONENT   "${paraview_component}")
endif ()
