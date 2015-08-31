if (NOT plugin_project)
  message(FATAL_ERROR "No 'plugin_project' given!")
endif ()
if (NOT ${plugin_project}_name)
  message(FATAL_ERROR "No name for ${plugin_project} given!")
endif ()
if (NOT ${plugin_project}_install_files)
  message(FATAL_ERROR "No files to install for ${plugin_project}!")
endif ()

set(paraview_binary_dir)
if (TARGET paraview)
  set(paraview_binary_dir "<BINARY_DIR>")
  _ep_replace_location_tags(paraview paraview_binary_dir)
endif ()

set(paraview_plugin_extra_options)
if (WIN32)
  find_program(7Z_EXE NAMES 7z)

  if (7Z_EXE)
    list(APPEND paraview_plugin_extra_options
      -D7Z_EXE:FILEPATH=${7Z_EXE})
  else ()
    message(WARNING "Unable to find 7z; will generate a .tgz file instead for ${plugin_project}!")
  endif ()
endif ()

superbuild_add_project("${plugin_project}"
  DEPENDS paraview ${${plugin_project}_depends}
  DEPENDS_OPTIONAL ${${plugin_project}_depends_optional}

  CMAKE_ARGS
    -DParaView_DIR:PATH=${paraview_binary_dir}
    -DVTK_DIR:PATH=${paraview_binary_dir}/VTK
    ${${plugin_project}_options}

  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dparaview_binary_dir:PATH=${paraview_binary_dir}
      -Dplugin_name:STRING=${${plugin_project}_name}
      -Dbundle_name:STRING=${CMAKE_CURRENT_BINARY_DIR}/${${plugin_project}_name}
      -Dbundle_suffix_file:STRING=${CMAKE_BINARY_DIR}/paraview_version.cmake
      -Dtmp_dir:PATH=<TMP_DIR>
      "-Dinstall_files:STRING=${${plugin_project}_install_files}"
      "-Dfixup_plugin_paths:STRING=${${plugin_project}_fixup_plugin_paths}"
      ${paraview_plugin_extra_options}
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/paraview.plugin.install.cmake"

  ${${plugin_project}_arguments})
