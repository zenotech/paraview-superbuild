cmake_minimum_required(VERSION 3.12)

set(nsis_url_root "https://www.paraview.org/files/dependencies")

set(nsis_version "3.06.1")
if ("$ENV{CMAKE_CONFIGURATION}" MATCHES "windows")
  set(nsis_subdir "nsis-${nsis_version}")
  set(sha256sum "d463ad11aa191ab5ae64edb3a439a4a4a7a3e277fcb138254317254f7111fba7")
else ()
  message(FATAL_ERROR
    "Unknown platform for nsis")
endif ()
set(filename "${nsis_subdir}.zip")

# Download the file.
file(DOWNLOAD
  "${nsis_url_root}/${filename}"
  ".gitlab/${filename}"
  STATUS download_status
  EXPECTED_HASH "SHA256=${sha256sum}")

# Check the download status.
list(GET download_status 0 res)
if (res)
  list(GET download_status 1 err)
  message(FATAL_ERROR
    "Failed to download ${filename}: ${err}")
endif ()

# Extract the file.
execute_process(
  COMMAND
    "${CMAKE_COMMAND}"
    -E tar
    xf "${filename}"
  WORKING_DIRECTORY ".gitlab"
  RESULT_VARIABLE res
  ERROR_VARIABLE err
  ERROR_STRIP_TRAILING_WHITESPACE)
if (res)
  message(FATAL_ERROR
    "Failed to extract ${filename}: ${err}")
endif ()

# Move to a predictable prefix.
file(RENAME
  ".gitlab/${nsis_subdir}"
  ".gitlab/nsis")
