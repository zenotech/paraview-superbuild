cmake_minimum_required(VERSION 3.5)

project(build-mesa)

if (APPLE OR NOT UNIX)
  message(FATAL_ERROR "Building Mesa is only supported on Linux")
endif ()

function (superbuild_find_projects var)
  set(projects
    bzip2
    cxx11
    egl
    llvm
    mesa
    osmesa
    png
    python
    zlib)

  set("${var}"
    ${projects}
    PARENT_SCOPE)
endfunction ()

get_filename_component(paraview_superbuild_dir "${CMAKE_CURRENT_LIST_DIR}" DIRECTORY)
get_filename_component(paraview_superbuild_dir "${paraview_superbuild_dir}" DIRECTORY)

list(APPEND superbuild_version_files
  "${paraview_superbuild_dir}/versions.cmake")
list(APPEND superbuild_project_roots
  "${paraview_superbuild_dir}/projects")
add_subdirectory("${paraview_superbuild_dir}/superbuild" "${CMAKE_CURRENT_BINARY_DIR}/superbuild")
