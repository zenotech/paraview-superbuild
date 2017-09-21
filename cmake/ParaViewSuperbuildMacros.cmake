macro (paraview_superbuild_add_pdf name outname)
  superbuild_add_project("${name}"
    DOWNLOAD_NO_EXTRACT 1
    CONFIGURE_COMMAND
      ""
    BUILD_COMMAND
      ""
    INSTALL_COMMAND
      "${CMAKE_COMMAND}" -E copy_if_different
        <DOWNLOADED_FILE>
        "<INSTALL_DIR>/doc/${outname}")

  if (${name}_enabled)
    set("${name}_pdf" "${superbuild_install_location}/doc/${outname}")
  endif ()
endmacro ()

function (paraview_add_plugin _name)
  set(plugin_name)
  set(ep_arguments)
  set(grab)

  foreach (arg IN LISTS ARGN)
    if (arg STREQUAL "PLUGIN_NAME")
      set(grab plugin_name)
    elseif (arg MATCHES "${_ep_keywords_ExternalProject_Add}")
      set(grab ep_arguments)
      list(APPEND ep_arguments
        "${arg}")
    elseif (grab)
      list(APPEND "${grab}"
        "${arg}")
    endif ()
  endforeach ()

  superbuild_add_project("${_name}"
    ${ep_arguments}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND "")

  if (NOT plugin_name)
    set(plugin_name "${_name}")
  endif ()

  superbuild_add_extra_cmake_args(
    "-DPARAVIEW_BUILD_PLUGIN_${plugin_name}:BOOL=ON")

  if (NOT superbuild_build_phase)
    set_property(GLOBAL APPEND
      PROPERTY
        paraview_plugins "${_name}")
  endif ()

  set("${_name}_arguments"
    "${${_name}_arguments}"
    PARENT_SCOPE)
endfunction ()

function (paraview_add_plugins_external)
  set(paraview_PLUGINS_EXTERNAL ""
    CACHE STRING "List of plugins to build externally")

  set(plugin_cmake_args)
  set(plugin_paths)
  foreach (plugin IN LISTS paraview_PLUGINS_EXTERNAL)
    set("paraview_PLUGIN_${plugin}_PATH" ""
      CACHE PATH "Path to the source directory of the ${name} plugin")
    if (NOT EXISTS "${paraview_PLUGIN_${plugin}_PATH}")
      message(FATAL_ERROR
        "The path for the ${plugin} plugin does not exist: "
        "${paraview_PLUGIN_${plugin}_PATH}.")
    endif ()

    list(APPEND plugin_cmake_args
      "-DPARAVIEW_BUILD_PLUGIN_${plugin}:BOOL=ON")
    list(APPEND plugin_paths
      "${paraview_PLUGIN_${plugin}_PATH}")
  endforeach ()

  superbuild_add_dummy_project(paraviewpluginsexternal)

  superbuild_add_extra_cmake_args(${plugin_cmake_args})

  if (NOT superbuild_build_phase)
    set_property(GLOBAL
      PROPERTY
        paraview_plugin_dirs_external "${plugin_paths}")
  endif ()

  set(paraviewpluginsexternal_arguments
    "${paraviewpluginsexternal_arguments}"
    PARENT_SCOPE)
endfunction ()
