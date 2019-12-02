set(pv_cmake_dir "${install_location}/lib/cmake/paraview-${paraview_version}")
if (NOT EXISTS "${pv_cmake_dir}")
  message(FATAL_ERROR "The ParaView CMake directory does not exist: ${pv_cmake_dir}")
endif ()
file(GLOB cmake_files
  "${pv_cmake_dir}/ParaViewTargets*.cmake"
  "${pv_cmake_dir}/VTKConfig.cmake")

if (APPLE)
  set(sed_cmd_prefix "sed -i \"\"")
  set(sed_cmd_suffix)
else ()
  set(sed_cmd_prefix sed )
  set(sed_cmd_suffix -i)
endif ()

foreach (cmake_file IN LISTS cmake_files)
  execute_process(
    COMMAND
      ${sed_cmd_prefix}
      -e "s|${install_location}|\${_IMPORT_PREFIX}|g"
      ${sed_cmd_suffix}
      "${cmake_file}"
    RESULT_VARIABLE RES)
  if (NOT RES EQUAL 0)
    message(FATAL_ERROR "Failed to patch ${cmake_file}")
  endif ()
endforeach ()
