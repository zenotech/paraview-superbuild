include("${CMAKE_CURRENT_LIST_DIR}/gitlab_ci.cmake")

# Read the files from the build directory.
ctest_read_custom_files("${CTEST_BINARY_DIRECTORY}")

# Pick up from where the configure left off.
ctest_start(APPEND)

ctest_test(
  RETURN_VALUE test_result
  INCLUDE "cpack-")

ctest_submit(PARTS Test)

# upload generated packages to CDash
file(GLOB files
  "${CTEST_BINARY_DIRECTORY}/*.dmg"
  "${CTEST_BINARY_DIRECTORY}/*.exe"
  "${CTEST_BINARY_DIRECTORY}/*.tar.*"
  "${CTEST_BINARY_DIRECTORY}/*.zip")
if (files)
  ctest_upload(FILES ${files})
  ctest_submit(PARTS Upload)
endif()

if (test_result)
  message(FATAL_ERROR
    "Failed to test")
endif ()
