file(GLOB pv_cmake_dir "${CMAKE_CURRENT_BINARY_DIR}/lib/cmake/paraview-*")
file(GLOB cmake_files
  "${pv_cmake_dir}/ParaViewTargets*.cmake"
  "${pv_cmake_dir}/VTKConfig.cmake")
foreach (cmake_file IN LISTS cmake_files)
  execute_process(
    COMMAND sed -e "s|${CMAKE_CURRENT_BINARY_DIR}|\${_IMPORT_PREFIX}|g"
    -i "${cmake_file}"
    RESULT_VARIABLE RES)
  if (NOT RES EQUAL 0)
    message(FATAL_ERROR "Failed to patch ${cmake_file}")
  endif ()
endforeach ()
set(cmake_file "${pv_cmake_dir}/Modules/vtkCommonCore.cmake")
execute_process(
  COMMAND sed -e "s|${CMAKE_CURRENT_BINARY_DIR}|\${VTK_INSTALL_PREFIX}|g"
    -i "${cmake_file}"
  RESULT_VARIABLE RES)
if (NOT RES EQUAL 0)
  message(FATAL_ERROR "Failed to patch ${cmake_file}")
endif ()
