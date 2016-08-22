set(CPACK_PACKAGE_NAME "ParaViewSDK")
set(package_filename "${PARAVIEWSDK_PACKAGE_FILE_NAME}")
include(paraview.bundle.common)

set(plugins_file "${CMAKE_CURRENT_BINARY_DIR}/paraview.plugins")
paraview_add_plugin("${plugins_file}" ${paraview_plugins})

# Workaround to patch any hard-coded paths to the build folder
install(CODE "
  file(GLOB_RECURSE cmake_files \"${superbuild_install_location}/lib/*.cmake\")
  foreach (cmake_file IN LISTS cmake_files)
    execute_process(
      COMMAND sed
              -i
              -e \"s|${superbuild_install_location}|\\\${_IMPORT_PREFIX}|g\"
              \${cmake_file})
  endforeach ()"
  COMPONENT superbuild)
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
    USE_SOURCE_PERMISSIONS)

  # Install any non-ParaView Python libraries
  if (EXISTS "${superbuild_install_location}/lib/python2.7")
    install(
      DIRECTORY   "${superbuild_install_location}/lib/python2.7"
      DESTINATION lib
      COMPONENT   superbuild
      USE_SOURCE_PERMISSIONS)
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
  file(STRINGS "${cmake_file}" lines REGEX "\\\${_IMPORT_PREFIX}[^;\\\"]+")
  foreach (line IN LISTS lines)
    string(REGEX MATCHALL "\\\${_IMPORT_PREFIX}[^;\\\"]+" fnames "${line}")

    # Ignore static libraries
    list(FILTER fnames EXCLUDE REGEX "\\${CMAKE_STATIC_LIBRARY_SUFFIX}$")

    list(APPEND libraries_referenced_by_cmake
      ${fnames})
  endforeach ()
endforeach ()
list(REMOVE_DUPLICATES libraries_referenced_by_cmake)

# Now grab extra python SOs
file(GLOB_RECURSE paraview_python_modules
  "${superbuild_install_location}/lib/paraview-${paraview_version}/site-packages/*${CMAKE_SHARED_MODULE_SUFFIX}")
file(GLOB_RECURSE python_modules
  "${superbuild_install_location}/lib/python2.7/*${CMAKE_SHARED_MODULE_SUFFIX}")

# Now resolve their symlinks
set(libraries_to_install)
foreach (fname IN LISTS libraries_referenced_by_cmake paraview_python_modules python_modules)
  string(REPLACE "\${_IMPORT_PREFIX}" "${real_superbuild_install_location}" fname "${fname}")
  get_filename_component(fname "${fname}" ABSOLUTE)

  if (NOT EXISTS "${fname}" OR IS_DIRECTORY "${fname}")
    continue ()
  endif ()

  # Skip files outside the install directory
  if (NOT ("${fname}" MATCHES "^${superbuild_install_location}/"))
    continue ()
  endif ()

  if (IS_SYMLINK "${fname}")
    get_filename_component(resolved_fname "${fname}" REALPATH)

    # Skip symlinks that point to outside the install directory
    if (NOT ("${resolved_fname}" MATCHES "^${superbuild_install_location}/"))
      continue ()
    endif ()

    list(APPEND libraries_to_install
      "${resolved_fname}")
  endif ()

  list(APPEND libraries_to_install
    "${fname}")
endforeach ()

function (install_superbuild_binary fname)
  get_filename_component(fname_dir "${fname}" DIRECTORY)
  string(REPLACE "${superbuild_install_location}/" "" fname_inst "${fname_dir}")
  install(
    PROGRAMS    "${fname}"
    DESTINATION "${fname_inst}"
    COMPONENT   superbuild)
endfunction ()

include(GetPrerequisites)
set(all_binaries)
set(dependency_search_paths
  "${superbuild_install_location}/lib/paraview-${paraview_version}"
  "${superbuild_install_location}/lib/paraview-${paraview_version}/site-packages"
  "${superbuild_install_location}/lib"
  "${superbuild_install_location}/lib/python2.7"
  "${superbuild_install_location}/lib/python2.7/lib-dynload")
foreach (fname IN LISTS libraries_to_install binaries_to_install)
  if (NOT ("${fname}" MATCHES "^${superbuild_install_location}/"))
    continue ()
  endif ()
  list(APPEND all_binaries "${fname}")

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
  list(FILTER dependencies INCLUDE REGEX "^${superbuild_install_location}/")

  foreach (dep IN LISTS dependencies)
    if (IS_SYMLINK "${dep}")
      get_filename_component(resolved_dep "${dep}" REALPATH)

      # Drop any dependency that is a symlink to outside the install dir
      if (NOT ("${resolved_dep}" MATCHES "^${superbuild_install_location}/"))
        continue ()
      endif ()

      list(APPEND all_binaries
        "${resolved_dep}")
    endif ()

    list(APPEND all_binaries
      "${dep}")
  endforeach ()
endforeach ()
list(REMOVE_DUPLICATES all_binaries)

# Now install all dependencies in the same location they exist in the
# superbuild install tree.
foreach (fname IN LISTS all_binaries)
  install_superbuild_binary("${fname}")
endforeach ()
