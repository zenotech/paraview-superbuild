# Prepares binaries for testing.
# BINARY_DIRECTORY : Directory where the binary tar balls/zip/dmg etc are
#                    present.
# OUTPUT_DIRECTORY : Directory under which the paraview package must be
# unravelled.
# GLOB_PATTERN     : File pattern to glob for when locating the package file.

# Remove the output directory to begin with.
file(REMOVE_RECURSE "${OUTPUT_DIRECTORY}")

file(MAKE_DIRECTORY "${OUTPUT_DIRECTORY}")

# Find the package.
file(GLOB files "${BINARY_DIRECTORY}/${GLOB_PATTERN}")

list(LENGTH files files_length)
if(files_length EQUAL 0)
  message(FATAL_ERROR "Failed to locate package file using '${BINARY_DIRECTORY}/${GLOB_PATTERN}'")
elseif(files_length GREATER 1)
  message(FATAL_ERROR "Multiple package files found using '${BINARY_DIRECTORY}/${GLOB_PATTERN}':\n${files}")
endif()

message("Using package '${files}'")
set(file "${files}")
get_filename_component(file_ext "${file}" EXT)
string(TOLOWER file_ext "${file_ext}")
if(file_ext MATCHES "(\\.|=)(7z|tar\\.bz2|tar\\.gz|tar\\.xz|tbz2|tgz|txz|zip)$")
  # This works for Windows and Linux.
  file(MAKE_DIRECTORY "${OUTPUT_DIRECTORY}/__Extract__")
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar xfz ${file}
    WORKING_DIRECTORY ${OUTPUT_DIRECTORY}/__Extract__
    OUTPUT_VARIABLE ov
    ERROR_VARIABLE ov
    RESULT_VARIABLE rv)
  if(rv)
    message(FATAL_ERROR
      "Failed to extract the package. Output/Error messages are:
=======================================================
${ov}
=======================================================\n")
  endif()

  # Strip empty directories and move the root to ${OUTPUT}.
  file(GLOB contents "${OUTPUT_DIRECTORY}/__Extract__/*")
  list(LENGTH contents contents_length)
  if(NOT contents_length EQUAL 1 OR NOT IS_DIRECTORY "${contents}")
    set(contents "${OUTPUT_DIRECTORY}/__Extract__")
  endif()
  get_filename_component(templocation "${OUTPUT_DIRECTORY}/../__Package__" ABSOLUTE)
  file(RENAME "${contents}" "${templocation}")
  file(REMOVE_RECURSE "${OUTPUT_DIRECTORY}")
  file(RENAME "${templocation}" "${OUTPUT_DIRECTORY}")
  message("Package `installed` under '${OUTPUT_DIRECTORY}'")

elseif(file_ext MATCHES "\\.dmg$")
  execute_process(
    COMMAND /bin/sh -c "yes | hdiutil attach -mountpoint ${OUTPUT_DIRECTORY}/__Mount__ ${file}"
    RESULT_VARIABLE rv
    OUTPUT_VARIABLE ov
    ERROR_VARIABLE ov)
  if (rv)
    message(FATAL_ERROR "Failed to mount volume '${file}'!!! Output/Error messages are:
=======================================================
${ov}
=======================================================\n")
  endif()
  message("Mounted volume as '${OUTPUT_DIRECTORY}/__Mount__'")

  # Find the app to copy.
  file(GLOB volume_contents "${OUTPUT_DIRECTORY}/__Mount__/*.app")
  foreach(file IN LISTS volume_contents)
    get_filename_component(appname "${file}" NAME)
    message("Copying '${appname}'")
    execute_process(
      COMMAND ${CMAKE_COMMAND} -E copy_directory
              "${file}"
              "${OUTPUT_DIRECTORY}/__Extract__/${appname}"
      RESULT_VARIABLE rv
      OUTPUT_VARIABLE ov
      ERROR_VARIABLE ov)
    if (rv)
      message(FATAL_ERROR "Failed to copy from volume to directory!!! Output/Error message are:
=======================================================
${ov}
=======================================================\n")
    endif()
  endforeach()

  # unmount volume
  execute_process(COMMAND hdiutil detach "${OUTPUT_DIRECTORY}/__Mount__")

  # Now put the contents in __Extract__ to the same location as ${OUTPUT_DIRECTORY}}
  get_filename_component(templocation "${OUTPUT_DIRECTORY}/../__Package__" ABSOLUTE)
  file(RENAME "${OUTPUT_DIRECTORY}/__Extract__" "${templocation}")
  file(REMOVE_RECURSE "${OUTPUT_DIRECTORY}")
  file(RENAME "${templocation}" "${OUTPUT_DIRECTORY}")
  message("Package `installed` under '${OUTPUT_DIRECTORY}'")
endif()
