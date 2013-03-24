#=============================================================================
# Ask user what the target machine is, so that we can choose the right
# right build hints and patches later on.
#
macro(query_target_machine)
  set(cross_target "generic" CACHE STRING
    "Platform to cross compile for, either generic|bgp_xlc|xk7_gnu")
  set_property(CACHE cross_target PROPERTY STRINGS
    "generic" "bgp_xlc" "xk7_gnu")

  set(CROSS_BUILD_SITE "" CACHE STRING
    "Specify Site to load appropriate configuration defaults, if available.")
endmacro()

#=============================================================================
# Configures the cmake files that describe how to cross compile paraview
# From the ${cross_target} directory into the build tree.
#
macro(do_cross_platform_settings)
  #copy toolchains
  configure_file(
    ${CMAKE_SOURCE_DIR}/CMake/crosscompile/${cross_target}/ToolChain.cmake
    ${CMAKE_BINARY_DIR}/crosscompile/ParaViewToolChain.cmake
    @ONLY
  )
  set(PARAVIEW_TOOLCHAIN_FILE
    "${CMAKE_BINARY_DIR}/crosscompile/ParaViewToolChain.cmake")

  #configure tryrunresults
  #see CMake/crosscompile/trycompiler.py for sample of how to generate new ones
  configure_file(
    ${CMAKE_SOURCE_DIR}/CMake/crosscompile/${cross_target}/ParaViewTryRunResults.cmake
    ${CMAKE_BINARY_DIR}/crosscompile/ParaViewTryRunResults.cmake
    @ONLY
  )
  set(PARAVIEW_TRYRUN_FILE
    "${CMAKE_BINARY_DIR}/crosscompile/ParaViewTryRunResults.cmake")

  #configure additional platform specific options
  string(TOLOWER "${CROSS_BUILD_SITE}" lsite)
  set (site-specific-defaults
    ${CMAKE_SOURCE_DIR}/CMake/crosscompile/${cross_target}/ParaViewDefaults.${lsite}.cmake)
  if (EXISTS "${site-specific-defaults}")
    configure_file(
      "${site-specific-defaults}"
      ${CMAKE_BINARY_DIR}/crosscompile/ParaViewDefaults.cmake
      @ONLY)
  else()
    configure_file(
      ${CMAKE_SOURCE_DIR}/CMake/crosscompile/${cross_target}/ParaViewDefaults.cmake
      ${CMAKE_BINARY_DIR}/crosscompile/ParaViewDefaults.cmake
      @ONLY)
  endif()
  set(CROSS_OPTIONS_FILE
    "${CMAKE_BINARY_DIR}/crosscompile/ParaViewDefaults.cmake")
  include(${CROSS_OPTIONS_FILE})
endmacro()

#=============================================================================
#Asks user where the results of the hosttools pass are so that it can
#use them in the cross compile pass.
#
macro(find_hosttools)
  set(PARAVIEW_HOSTTOOLS_DIR ${CMAKE_BINARY_DIR}/../tools/toolsparaview/src/toolsparaview-build/ CACHE PATH
    "Location of host built paraview compile tools directory")
  set(PYTHON_HOST_EXE ${CMAKE_BINARY_DIR}/../tools/install/bin/python CACHE PATH
    "Location of host built python executable")
  set(PYTHON_HOST_LIBDIR ${CMAKE_BINARY_DIR}/../tools/install/lib CACHE PATH
    "Location of host built python libraries")
  set(BOOST_HOST_INCLUDEDIR ${CMAKE_BINARY_DIR}/../tools/install/include CACHE PATH
    "Location of host built boost headers")
endmacro()

#=============================================================================
# looks for a patch file for the current ${cross_target} and ${_project}
# patch is given arguments from the ${project}_patch.cmake file if
# one exists, otherwise it uses defaults
#
macro(conditionally_patch_for_crosscompilation _project)
  #get options for how to apply this specific patch
  set(_subdir)
  set(_patchlevel 1)
  set(_step 1)
  if (EXISTS
     "${SuperBuild_CMAKE_DIR}/crosscompile/${cross_target}/${_project}_patch.cmake"
     )
     include("${SuperBuild_CMAKE_DIR}/crosscompile/${cross_target}/${_project}_patch.cmake")
  endif()

  #apply the patch if one exists for this project and target platform
  if (EXISTS "${SuperBuild_CMAKE_DIR}/crosscompile/${cross_target}/${_project}.patch")
    add_external_project_step(patch${_step}
      COMMENT "Applying ${cross_target} specific patches for ${_project}"
      COMMAND sh "${SuperBuild_CMAKE_DIR}/crosscompile/patcher.sh" "<SOURCE_DIR>/${_subdir}" -p${_patchlevel} "${SuperBuild_CMAKE_DIR}/crosscompile/${cross_target}/${_project}.patch"
      DEPENDEES update
      DEPENDERS patch)
  else()
    message("No ${_project} patch step for ${cross_target}")
  endif()
endmacro()
