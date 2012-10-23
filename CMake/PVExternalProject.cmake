# Extends ExternalProject_Add(...) by adding a new option.
#  PROCESS_ENVIRONMENT <environment variables>
# When present the BUILD_COMMAND and CONFIGURE_COMMAND are executed as a
# sub-process (using execute_process()) so that the sepecified environment
# is passed on to the executed command (which does not happen by default).
# This will be deprecated once CMake starts supporting it.

include(ExternalProject)

string(REPLACE ")" "|PROCESS_ENVIRONMENT)"
  _ep_keywords_PVExternalProject_Add "${_ep_keywords_ExternalProject_Add}")

#------------------------------------------------------------------------------
# win32 version of the macro that simply strips the PROCESS_ENVIRONMENT and call
# ExternalProject_Add().
function(_PVExternalProject_Add_Win32 name)
    set (arguments)
    set (optional_depends)
    set (accumulate TRUE)
    foreach(arg ${ARGN})
      if ("${arg}" MATCHES "^PROCESS_ENVIRONMENT$")
        set (accumulate FALSE)
      elseif ("${arg}" MATCHES "${_ep_keywords_ExternalProject_Add}")
        set (accumulate TRUE)
      endif()
      if (accumulate)
        list(APPEND arguments "${arg}")
      endif()
    endforeach()
    ExternalProject_Add(${name} ${arguments})
    unset(arguments)
    unset(optional_depends)
    unset(accumulate)
endfunction()

function (PVExternalProject_Add name)
  if (WIN32)
     _PVExternalProject_Add_Win32(${name} ${ARGN})
    return()
  endif()

  # process arguments are detect USE_ENVIRONMENT, BUILD_COMMAND and
  # CONFIGURE_COMMAND.

  # just create a temporary target so we can set target properties.
  add_custom_target(pv-${name})
  _ep_parse_arguments(PVExternalProject_Add pv-${name} _EP_ "${ARGN}")

  get_property(has_process_environment TARGET pv-${name}
    PROPERTY _EP_PROCESS_ENVIRONMENT SET)
  if (NOT has_process_environment)
    ExternalProject_Add(${name} ${ARGN})
    return()
  endif()

  set (new_argn)

  # check if we have a BUILD_COMMAND or CONFIGURE_COMMAND.
  get_property(has_build_command TARGET pv-${name}
    PROPERTY _EP_BUILD_COMMAND SET)
  if(NOT has_build_command)
    # if no BUILD_COMMAND was specified, then the default build cmd is going to
    # be used, but then too we want to environment to be setup correctly. So we
    # obtain the default build command.
    _ep_get_build_command(pv-${name} BUILD cmd)
    if("${cmd}" MATCHES "^\\$\\(MAKE\\)")
      # GNU make recognizes the string "$(MAKE)" as recursive make, so
      # ensure that it appears directly in the makefile.
      string(REGEX REPLACE "^\\$\\(MAKE\\)" "${CMAKE_MAKE_PROGRAM} -j5" cmd "${cmd}")
    endif()

    set_property(TARGET pv-${name} PROPERTY _EP_BUILD_COMMAND "${cmd}")
    set (has_build_command 1)

    # when we customize the build command, the install command gets overridden
    # as well and we need to explicitly specify it too.
    get_property(has_install_command TARGET pv-${name} PROPERTY
    _EP_INSTALL_COMMAND SET)

    if (NOT has_install_command)
      _ep_get_build_command(pv-${name} INSTALL install_cmd)
      if (install_cmd)
        set (new_argn ${new_argn} INSTALL_COMMAND ${install_cmd})
      endif()
    endif()
  endif()

  get_property(has_configure_command TARGET pv-${name}
    PROPERTY _EP_CONFIGURE_COMMAND SET)

  if (has_configure_command)
    set(new_argn ${new_argn}
      CONFIGURE_COMMAND
      ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/pv-${name}-configure.cmake)
  endif()

  if (has_build_command)
    set(new_argn ${new_argn}
      BUILD_COMMAND
      ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/pv-${name}-build.cmake)
  endif()

  # now strip PROCESS_ENVIRONMENT from argments.
  set (skip TRUE)
  foreach(arg IN LISTS ARGN)
    if (arg MATCHES "${_ep_keywords_PVExternalProject_Add}")
      if (arg MATCHES "^(PROCESS_ENVIRONMENT|BUILD_COMMAND|CONFIGURE_COMMAND)$")
        set (skip FALSE)
      else()
        set (skip TRUE)
      endif ()
    endif()
    if (skip)
      list(APPEND new_argn ${arg})
    endif()
  endforeach()
  ExternalProject_Add(${name} ${new_argn})

  # configure the scripts after the call ExternalProject_Add() since that sets
  # up the directories correctly.
  get_target_property(process_environment pv-${name}
    _EP_PROCESS_ENVIRONMENT)
  _ep_replace_location_tags(${name} process_environment)

  if (has_configure_command)
    get_target_property(step_command pv-${name} _EP_CONFIGURE_COMMAND)
    _ep_replace_location_tags(${name} step_command)
    configure_file(${SuperBuild_CMAKE_DIR}/pep_configure.cmake.in
      ${CMAKE_CURRENT_BINARY_DIR}/pv-${name}-configure.cmake
      @ONLY
      )
  endif()

  if (has_build_command)
    get_target_property(step_command pv-${name} _EP_BUILD_COMMAND)
    _ep_replace_location_tags(${name} step_command)
    configure_file(${SuperBuild_CMAKE_DIR}/pep_configure.cmake.in
      ${CMAKE_CURRENT_BINARY_DIR}/pv-${name}-build.cmake
      @ONLY)
  endif()
endfunction()
