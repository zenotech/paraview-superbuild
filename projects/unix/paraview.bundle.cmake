include(paraview-version)

set(paraview_doc_dir "share/paraview-${paraview_version}/doc")
set(paraview_data_dir "share/paraview-${paraview_version}/examples")
set(paraview_translations_dir "share/paraview-${paraview_version}/translations")
set(paraview_materials_dir "share/paraview-${paraview_version}/materials")
set(paraview_kernels_nvidia_index_dir "share/paraview-${paraview_version}/kernels_nvidia_index")
set(paraview_plugin_path "lib/paraview-${paraview_version}/plugins")
set(paraview_license_path "share/licenses")
set(paraview_spdx_path "share/paraview-${paraview_version}")
include(paraview.bundle.common)

set(paraview_component ParaView)
include(paraview.bundle.unix)

if (paraview_has_gui)
  install(
    DIRECTORY   "${superbuild_install_location}/share/metainfo"
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
