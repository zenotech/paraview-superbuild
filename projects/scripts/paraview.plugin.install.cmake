include("${bundle_suffix_file}")

set(plugin_location "${tmp_location}/${plugin_name}${bundle_suffix}")

file(REMOVE_RECURSE "${plugin_location}")
file(MAKE_DIRECTORY "${plugin_location}")

file(GLOB all_files
  ${install_files})

file(
  COPY        ${all_files}
  DESTINATION "${plugin_location}")

if (APPLE)
  execute_process(
    COMMAND "${CMAKE_CURRENT_LIST_DIR}/apple/fixup_plugin.py"
            # The directory containing the plugin dylibs.
            "${plugin_location}"
            # names to replace (in order)
            "${paraview_binary_location}/lib/=@executable_path/../Libraries/"
            ${fixup_plugin_paths})
endif ()

function (make_plugin_tarball working_dir name)
  if (7Z_EXE)
    set(cmd "${7Z_EXE}" a)
    set(ext ".zip")
  else ()
    set(cmd "${CMAKE_COMMAND}" -E tar cvzf)
    set(ext ".tgz")
  endif ()
  execute_process(
    COMMAND ${cmd}
            "${name}${ext}"
            ${ARGN}
    WORKING_DIRECTORY "${working_dir}"
    ERROR_VARIABLE    out
    OUTPUT_VARIABLE   out
    RESULT_VARIABLE   res)

  if (res)
    message(FATAL_ERROR "Failed to create the plugin artifact: ${out}")
  endif ()
endfunction ()

make_plugin_tarball("${tmp_location}"
  "${bundle_name}${bundle_suffix}"
  "${plugin_name}${bundle_suffix}")
