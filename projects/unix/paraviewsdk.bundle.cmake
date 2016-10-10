set(CPACK_PACKAGE_NAME "ParaViewSDK")
set(package_filename "${PARAVIEWSDK_PACKAGE_FILE_NAME}")
include(paraview.bundle.common)

set(plugins_file "${CMAKE_CURRENT_BINARY_DIR}/paraview.plugins")
paraview_add_plugin("${plugins_file}" ${paraview_plugins})

get_filename_component(real_superbuild_install_location "${superbuild_install_location}" REALPATH)

# Install ParaView CMake files
install(
  DIRECTORY   "${superbuild_install_location}/lib/cmake/paraview-${paraview_version}"
  DESTINATION lib/cmake
  COMPONENT   superbuild
  USE_SOURCE_PERMISSIONS)

# Install ParaView headers
install(
  DIRECTORY   "${superbuild_install_location}/include/paraview-${paraview_version}"
  DESTINATION include
  COMPONENT   superbuild
  USE_SOURCE_PERMISSIONS)

set(binaries_to_install)
foreach (paraview_executable IN LISTS paraview_executables)
  list(APPEND binaries_to_install
    "${superbuild_install_location}/bin/${paraview_executable}"
    "${superbuild_install_location}/lib/paraview-${paraview_version}/${paraview_executable}")
endforeach ()

if (python_enabled)
  # Install ParaView Python libraries
  install(
    DIRECTORY   "${superbuild_install_location}/lib/paraview-${paraview_version}/site-packages"
    DESTINATION "lib/paraview-${paraview_version}"
    COMPONENT   superbuild
    USE_SOURCE_PERMISSIONS
    PATTERN "__pycache__" EXCLUDE
    PATTERN "*.pyo" EXCLUDE
    PATTERN "*.pyc" EXCLUDE)

  # Install any non-ParaView Python libraries
  if (EXISTS "${superbuild_install_location}/lib/python2.7")
    install(
      DIRECTORY   "${superbuild_install_location}/lib/python2.7"
      DESTINATION lib
      COMPONENT   superbuild
      USE_SOURCE_PERMISSIONS
      PATTERN "__pycache__" EXCLUDE
      PATTERN "*.pyo" EXCLUDE
      PATTERN "*.pyc" EXCLUDE)
  endif ()

  # Install python binaries and symlinks
  if (NOT USE_SYSTEM_python)
    install(
      PROGRAMS    "${superbuild_install_location}/bin/python2.7-config"
                  "${superbuild_install_location}/bin/python2"
                  "${superbuild_install_location}/bin/python2-config"
                  "${superbuild_install_location}/bin/python"
                  "${superbuild_install_location}/bin/python-config"
      DESTINATION bin
      COMPONENT   superbuild)
    list(APPEND binaries_to_install
      "${superbuild_install_location}/bin/python2.7")
  endif ()
endif ()

# Extra TBB headers that are in the public interface
if (tbb_built_by_superbuild)
  install(
    DIRECTORY   "${superbuild_install_location}/include/tbb"
    DESTINATION "include/paraview-${paraview_version}"
    COMPONENT   superbuild
    USE_SOURCE_PERMISSIONS)
endif ()

############################################################
# The rest of this deals with installing dependencies
############################################################

# First, grab all the referenced targets from the CMake files
file(GLOB_RECURSE cmake_files "${superbuild_install_location}/lib/cmake/paraview-${paraview_version}/*.cmake")
set(libraries_referenced_by_cmake)
foreach (cmake_file IN LISTS cmake_files)
  file(STRINGS "${cmake_file}" lines REGEX "\\\${_IMPORT_PREFIX}[^;\\\">]+")
  foreach (line IN LISTS lines)
    string(REGEX MATCHALL "\\\${_IMPORT_PREFIX}[^;\\\">]+" fnames "${line}")
    list(APPEND libraries_referenced_by_cmake
      ${fnames})
  endforeach ()
endforeach ()
list(REMOVE_DUPLICATES libraries_referenced_by_cmake)

if (python_enabled)
  # Now grab extra python SOs
  file(GLOB_RECURSE paraview_python_modules
    "${real_superbuild_install_location}/lib/paraview-${paraview_version}/site-packages/*${CMAKE_SHARED_MODULE_SUFFIX}")
  file(GLOB_RECURSE python_modules
    "${real_superbuild_install_location}/lib/python2.7/*${CMAKE_SHARED_MODULE_SUFFIX}")
else ()
  set(paraview_python_modules)
  set(python_modules)
endif ()

set(full_mesa_libraries)
foreach(lib IN LISTS mesa_libraries)
  list(APPEND full_mesa_libraries "\${_IMPORT_PREFIX}/lib/lib${lib}.so")
endforeach ()

# Now resolve their symlinks
set(libraries_to_install)
foreach (fname IN LISTS full_mesa_libraries libraries_referenced_by_cmake paraview_python_modules python_modules)
  string(REPLACE "\${_IMPORT_PREFIX}" "${real_superbuild_install_location}" fname "${fname}")

  if (IS_DIRECTORY "${fname}")
    continue ()
  endif ()

  if (IS_SYMLINK "${fname}")
    get_filename_component(resolved_fname "${fname}" REALPATH)

    # Skip symlinks that point to outside the install directory
    if (NOT ("${resolved_fname}" MATCHES "^${real_superbuild_install_location}/"))
      continue ()
    endif ()

    list(APPEND libraries_to_install
      "${resolved_fname}")
  endif ()

  list(APPEND libraries_to_install
    "${fname}")
endforeach ()

function (list_append_unique var)
  foreach (value IN LISTS ARGN)
    list(FIND "${var}" "${value}" idx)
    if (idx EQUAL -1)
      list(APPEND "${var}" "${value}")
    endif ()
  endforeach ()

  set("${var}" "${${var}}" PARENT_SCOPE)
endfunction ()

function (_install_superbuild_file type fname)
  get_filename_component(fname_dir "${fname}" DIRECTORY)
  string(REPLACE "${superbuild_install_location}/" "" fname_inst "${fname_dir}")
  string(REPLACE "${real_superbuild_install_location}/" "" fname_inst "${fname_inst}")
  install(
    "${type}"   "${fname}"
    DESTINATION "${fname_inst}"
    COMPONENT   superbuild)
endfunction ()

function (install_superbuild_static_library fname)
  _install_superbuild_file(FILES "${fname}")
endfunction ()

function (install_superbuild_binary fname)
  _install_superbuild_file(PROGRAMS "${fname}")
endfunction ()

include(GetPrerequisites)
set(all_binaries)
set(dependency_search_paths
  "${real_superbuild_install_location}/lib/paraview-${paraview_version}"
  "${real_superbuild_install_location}/lib/paraview-${paraview_version}/site-packages"
  "${real_superbuild_install_location}/lib"
  "${real_superbuild_install_location}/lib/python2.7"
  "${real_superbuild_install_location}/lib/python2.7/lib-dynload")
foreach (fname IN LISTS libraries_to_install binaries_to_install)
  if (NOT ("${fname}" MATCHES "^(${real_superbuild_install_location}|${superbuild_install_location})/"))
    continue ()
  endif ()

  # Install static libraries separately.
  if (fname MATCHES "\\${CMAKE_STATIC_LIBRARY_SUFFIX}$")
    install_superbuild_static_library("${fname}")
    continue ()
  endif ()

  # Find the .so for any .so.X libraries.
  if (fname MATCHES "\\${CMAKE_SHARED_LIBRARY_SUFFIX}\\..*$")
    string(REGEX REPLACE "\\${CMAKE_SHARED_LIBRARY_SUFFIX}.*" "${CMAKE_SHARED_LIBRARY_SUFFIX}"
      shared_lib_link "${fname}")

    # Not all .so files exists apparently?
    if (EXISTS "${shared_lib_link}")
      # CMake installs .so -> .so.soname -> .so.soversion symlink chains for
      # shared libraries, so we need to install the middle link.
      if (IS_SYMLINK "${shared_lib_link}")
        # CMake doesn't provide something like this :( .
        execute_process(
          COMMAND readlink
                  "${shared_lib_link}"
          RESULT_VARIABLE res
          OUTPUT_VARIABLE link_target
          OUTPUT_STRIP_TRAILING_WHITESPACE)
        if (res)
          message(FATAL_ERROR "Failed to get the target for ${shared_lib_link}")
        endif ()

        get_filename_component(shared_lib_dir "${shared_lib_link}" DIRECTORY)
        install_superbuild_binary("${shared_lib_dir}/${link_target}")
      endif ()

      install_superbuild_binary("${shared_lib_link}")
    endif ()
  endif ()

  # The TBB libraries are special.
  if (fname MATCHES "libtbb(|_malloc)")
    install_superbuild_binary("${fname}")
    continue ()
  endif ()

  list_append_unique(all_binaries
    "${fname}")

  # We still want to install a symlink but only perform dependency resolution
  # on actual files.
  if (IS_SYMLINK "${fname}")
    continue ()
  endif ()

  get_prerequisites("${fname}" dependencies 1 1 "" "${dependency_search_paths}")

  if (NOT dependencies)
    continue ()
  endif ()

  # Drop any dependency outside the superbuild.
  list(FILTER dependencies INCLUDE REGEX "^(${real_superbuild_install_location}|${superbuild_install_location})/")

  foreach (dep IN LISTS dependencies)
    if (IS_SYMLINK "${dep}")
      # Symlinks better not cross the root directory. Bad install, bad.
      get_filename_component(resolved_dep "${dep}" REALPATH)

      list_append_unique(all_binaries
        "${resolved_dep}")
    endif ()

    list_append_unique(all_binaries
      "${dep}")
  endforeach ()
endforeach ()

# Now install all dependencies in the same location they exist in the
# superbuild install tree.
foreach (fname IN LISTS all_binaries)
  install_superbuild_binary("${fname}")
endforeach ()
