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
