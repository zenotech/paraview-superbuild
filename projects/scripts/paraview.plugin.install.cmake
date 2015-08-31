include("${bundle_suffix_file}")

set(plugin_dir "${tmp_dir}/${plugin_name}${bundle_suffix}")

file(REMOVE_RECURSE "${plugin_dir}")
file(MAKE_DIRECTORY "${plugin_dir}")

file(GLOB all_files
  ${install_files})

file(
  COPY        ${all_files}
  DESTINATION "${plugin_dir}")

if (APPLE)
  execute_process(
    COMMAND "${CMAKE_CURRENT_LIST_DIR}/apple/fixup_plugin.py"
            # The directory containing the plugin dylibs.
            "${plugin_dir}"
            # names to replace (in order)
            "${paraview_binary_dir}/lib/=@executable_path/../Libraries/"
            ${fixup_plugin_paths})
endif ()

function (make_plugin_tarball working_dir name)
  if (7Z_EXE)
    set(cmd "${7Z_EXE}" a)
    set(ext ".zip")
  else ()
    set(cmd "${CMAKE_COMMAND}" -E tar cvfz)
    set(ext ".tgz")
  endif ()
  execute_process(
    COMMAND ${cmd}
            "${name}${ext}"
            ${ARGN}
    WORKING_DIRECTORY
            "${working_dir}")
endfunction ()

make_plugin_tarball("${tmp_dir}"
  "${bundle_name}${bundle_suffix}"
  "${plugin_name}${bundle_suffix}")
