include("${CMAKE_CURRENT_LIST_DIR}/gitlab_ci.cmake")

# Read the files from the build directory.
ctest_read_custom_files("${CTEST_BINARY_DIRECTORY}")

# Pick up from where the configure left off.
ctest_start(APPEND)

ctest_test(
  RETURN_VALUE test_result
  INCLUDE "cpack-"
  OUTPUT_JUNIT "${CTEST_BINARY_DIRECTORY}/junit-package.xml")

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

include("${CMAKE_CURRENT_LIST_DIR}/ctest_annotation.cmake")
if (DEFINED build_id)
  ctest_annotation_report("${CTEST_BINARY_DIRECTORY}/annotations.json"
    "All Tests"     "https://open.cdash.org/viewTest.php?buildid=${build_id}"
    "Test Failures" "https://open.cdash.org/viewTest.php?onlyfailed&buildid=${build_id}"
    "Tests Not Run" "https://open.cdash.org/viewTest.php?onlynotrun&buildid=${build_id}"
    "Test Passes"   "https://open.cdash.org/viewTest.php?onlypassed&buildid=${build_id}"
    "Package Uploads" "https://open.cdash.org/build/${build_id}/files"
  )
endif ()

if (test_result)
  message(FATAL_ERROR
    "Failed to test")
endif ()
