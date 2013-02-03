# CMake script used to setup ParaView Nightly binary in order to test them
#
# The following variable need to be set by you:
# - PV_NIGHTLY_SUFFIX : Suffix that should be tested on that given computer.
#                       i.e.: glibc-2.3.6-NIGHTLY, glibc-2.15-NIGHTLY,
#                             10.6-10.7-NIGHTLY, 10.8-NIGHTLY, 10.8-NoMPI-NIGHTLY
#
# The following variable will be set for you:
# - PV_NIGHTLY_PARAVIEW : ParaView executable
# - PV_NIGHTLY_PVPYTHON : pvpython executable
# - PV_NIGHTLY_PVSERVER : pvserver executable
# - PV_NIGHTLY_PVBATCH  : pvbatch executable
# - PV_NIGHTLY_PVBLOT   : pvbatch executable
# - PV_NIGHTLY_PVDATASERVER   : dataserver executable
# - PV_NIGHTLY_PVRENDERSERVER : renderserver executable
message(STATUS "Binary test-suite is enabled")

#------------------------------------------------------------------------------
# Method to download a remote file. Will raise fatal errors on failure.
#   remoteurl:- url to download
#   localfilename:- path to locate file that the downloaded file will be saved as.
function(download remoteurl localfilename)
  # Download the file(s).
  file(DOWNLOAD "${remoteurl}"
                "${localfilename}"
                STATUS status
                LOG log
                SHOW_PROGRESS)
  list(GET status 0 status_code)
  list(GET status 1 status_string)
  if(NOT status_code EQUAL 0)
    message(FATAL_ERROR "error: downloading '${remoteurl}' failed
    status_code: ${status_code}
    status_string: ${status_string}
    log: ${log}")
  endif()
endfunction()

#------------------------------------------------------------------------------
function(extract filename destination)
  set(args "")
  if(filename MATCHES "(\\.bz2|\\.tar\\.gz|\\.tgz|\\.zip)$")
    set(args xfz)
  elseif(filename MATCHES "\\.tar$")
    set(args xf)
  else()
    # assume archive is already extracted.
    return()
  endif()
endfunction()

#------------------------------------------------------------------------------
set(SUPERBUILD_DOWNLOAD_BASE_URL "http://www.paraview.org/files/nightly")
set(PV_NIGHTLY_VERSION "3.98.1-RC1")
set(PV_NIGHTLY_PARAVIEW "")
set(PV_NIGHTLY_PVPYTHON "")
set(PV_NIGHTLY_PVSERVER "")
set(PV_NIGHTLY_PVBATCH  "")
set(PV_NIGHTLY_PVBLOT   "")
set(PV_NIGHTLY_PVDATASERVER   "")
set(PV_NIGHTLY_PVRENDERSERVER "")

if (64bit_build)
  set (PARAVIEW_BUILD_ARCHITECTURE "64")
else()
  set (PARAVIEW_BUILD_ARCHITECTURE "32")
endif()

set (PV_NIGHTLY_SUFFIX "${PARAVIEW_BUILD_ARCHITECTURE}bit-NIGHTLY"
     CACHE STRING "Suffix to use for binaries to download, e.g. 64bit-glibc-2.15-NIGHTLY")

# ---------------------------------
#             Linux
# ---------------------------------

if(UNIX AND NOT APPLE)
    set(paraview_nightly_server_filename "ParaView-${PV_NIGHTLY_VERSION}-Linux-${PV_NIGHTLY_SUFFIX}.tar.gz")
    ExternalProject_Add( Nightly-ParaView
       URL "${SUPERBUILD_DOWNLOAD_BASE_URL}/${paraview_nightly_server_filename}"
       SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly
       BINARY_DIR ""
       UPDATE_COMMAND ""
       CONFIGURE_COMMAND ""
       BUILD_COMMAND ""
       INSTALL_COMMAND ""
    )

    # Setup Unix specific path
    set(PV_NIGHTLY_PARAVIEW "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/bin/paraview")
    set(PV_NIGHTLY_PVPYTHON "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/bin/pvpython")
    set(PV_NIGHTLY_PVSERVER "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/bin/pvserver")
    set(PV_NIGHTLY_PVBATCH  "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/bin/pvbatch")
    set(PV_NIGHTLY_PVBLOT   "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/bin/pvblot")
    set(PV_NIGHTLY_PVDATASERVER   "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/bin/pvdataserver")
    set(PV_NIGHTLY_PVRENDERSERVER "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/bin/pvrenderserver")

endif()

# ---------------------------------
#             Mac
# ---------------------------------

if(APPLE)
    set(paraview_nightly_server_filename "ParaView-${PV_NIGHTLY_VERSION}-Darwin-${PV_NIGHTLY_SUFFIX}.dmg")
    set(paraview_nightly_filePath ${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/PVNightly.dmg)

    if(NOT EXISTS ${paraview_nightly_filePath})
       message("Downloading:  ${SUPERBUILD_DOWNLOAD_BASE_URL}/${paraview_nightly_server_filename}")
       # Download
       file(DOWNLOAD
          ${SUPERBUILD_DOWNLOAD_BASE_URL}/${paraview_nightly_server_filename}
          ${paraview_nightly_filePath}
       )

       # Mount DMG
       execute_process(
          COMMAND hdiutil attach ${paraview_nightly_filePath}
          RESULT_VARIABLE MOUNT_EXIT_CODE
          OUTPUT_VARIABLE output
          ERROR_VARIABLE errors)

       string(REPLACE "\t" ";" output_list "${output}")
       list(REVERSE output_list)
       list(GET output_list 0 arg)
       string(STRIP "${arg}" DIRECTORY_PATH)
       list(GET output_list 2 arg)
       string(STRIP "${arg}" DMG_MOUNT_PATH)

       # Copy application and unmount
       if (${MOUNT_EXIT_CODE} EQUAL 0)
          execute_process(
             COMMAND ${CMAKE_COMMAND} -E copy_directory "${DIRECTORY_PATH}/paraview.app" "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly"
          )
          execute_process(
             COMMAND hdiutil detach ${DMG_MOUNT_PATH}
             OUTPUT_VARIABLE output
             ERROR_VARIABLE errors
          )
       else()
          message("We were unable to mount the file ${paraview_superbuild_filePath}")
       endif()
    endif()

    # Setup Apple specific path
    set(PV_NIGHTLY_PARAVIEW "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/Contents/MacOS/paraview")
    set(PV_NIGHTLY_PVPYTHON "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/Contents/bin/pvpython")
    set(PV_NIGHTLY_PVSERVER "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/Contents/bin/pvserver")
    set(PV_NIGHTLY_PVBATCH  "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/Contents/bin/pvbatch")
    set(PV_NIGHTLY_PVBLOT   "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/Contents/bin/pvblot")
    set(PV_NIGHTLY_PVDATASERVER   "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/Contents/bin/pvdataserver")
    set(PV_NIGHTLY_PVRENDERSERVER "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/Contents/bin/pvrenderserver")

endif()

# ---------------------------------
#           Windows
# ---------------------------------

if(WIN32 OR WIN64)
    set(paraview_nightly_server_filename "ParaView-${PV_NIGHTLY_VERSION}-Windows-${PV_NIGHTLY_SUFFIX}.zip")

    ExternalProject_Add( Nightly-ParaView
       URL "${SUPERBUILD_DOWNLOAD_BASE_URL}/${paraview_nightly_server_filename}"
       SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly
       BINARY_DIR ""
       UPDATE_COMMAND ""
       CONFIGURE_COMMAND ""
       BUILD_COMMAND ""
       INSTALL_COMMAND ""
    )

    # Setup Windows specific path
    set(PV_NIGHTLY_PARAVIEW "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/bin/paraview.exe")
    set(PV_NIGHTLY_PVPYTHON "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/bin/pvpython.exe")
    set(PV_NIGHTLY_PVSERVER "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/bin/pvserver.exe")
    set(PV_NIGHTLY_PVBATCH  "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/bin/pvbatch.exe")
    set(PV_NIGHTLY_PVBLOT   "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/bin/pvblot.exe")
    set(PV_NIGHTLY_PVDATASERVER   "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/bin/pvdataserver.exe")
    set(PV_NIGHTLY_PVRENDERSERVER "${CMAKE_CURRENT_BINARY_DIR}/ParaViewNightly/bin/pvrenderserver.exe")

endif()

if (BUILD_TESTING)
  include(${CMAKE_CURRENT_SOURCE_DIR}/tests.cmake)
endif(BUILD_TESTING)
