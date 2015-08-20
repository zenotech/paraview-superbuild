# This needs to set a the following variables which are using in various
# bundling codes to determine ParaView version.
#   pv_version_major
#   pv_version_minor
#   pv_version_patch
#   pv_version_suffix
#   pv_version
#   pv_version_long

set (hardcoded_paraview_version "4.4.0-RC1")

function(_set_version_vars versiontext)
  string(REGEX MATCH "([0-9]+)\\.([0-9]+)\\.([0-9]+)[-]*(.*)" version_matches "${versiontext}")
  if(CMAKE_MATCH_0)
    set(full ${CMAKE_MATCH_0})
    set(major ${CMAKE_MATCH_1})
    set(minor ${CMAKE_MATCH_2})
    set(patch ${CMAKE_MATCH_3})
    set(patch_extra ${CMAKE_MATCH_4})

    set(pv_version "${major}.${minor}" PARENT_SCOPE)
    set(pv_version_major ${major} PARENT_SCOPE)
    set(pv_version_minor ${minor} PARENT_SCOPE)
    set(pv_version_patch ${patch} PARENT_SCOPE)
    set(pv_version_suffix ${patch_extra} PARENT_SCOPE)
    set(pv_version_long ${full} PARENT_SCOPE)
  endif()
endfunction()

if(ParaView_FROM_SOURCE_DIR)
  # We can use GitDescribe in this case, so let's use it.

  # First, set the vars using the hard coded version if everything fails.
  _set_version_vars(${hardcoded_paraview_version})
  include("${PARAVIEW_SOURCE_DIR}/Utilities/Git/Git.cmake" OPTIONAL)
  include("${PARAVIEW_SOURCE_DIR}/CMake/ParaViewDetermineVersion.cmake" OPTIONAL
    RESULT_VARIABLE status)
  if (status)
    message(STATUS "Using git-describe to determine ParaView version")
    # the ParaView module was correctly imported.
    determine_version("${PARAVIEW_SOURCE_DIR}" "${GIT_EXECUTABLE}" "__TMP")
    if (__TMP_VERSION_FULL)
      _set_version_vars(${__TMP_VERSION_FULL})
    endif()
  endif()

  # make the ParaView_VERSION variable internal to avoid confusion.
  set (PARAVIEW_VERSION "${hardcoded_paraview_version}" CACHE INTERNAL "")
else()
  # The user has to specify the version to use.
  set(PARAVIEW_VERSION "${hardcoded_paraview_version}" CACHE STRING
    "Specify the version number for the package being generated e.g. ${hardcoded_paraview_version}")
  mark_as_advanced(PARAVIEW_VERSION)
  _set_version_vars(${PARAVIEW_VERSION})
endif()

message(STATUS "Using ParaView Version: ${pv_version_long} (${pv_version_major}|${pv_version_minor}|${pv_version_patch}|${pv_version_suffix})")
