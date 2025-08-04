include("${CMAKE_CURRENT_LIST_DIR}/gitlab_ci.cmake")

# Read the files from the build directory.
ctest_read_custom_files("${CTEST_BINARY_DIRECTORY}")

# Pick up from where the configure left off.
ctest_start(APPEND)

include(ProcessorCount)
ProcessorCount(nproc)
if (NOT "$ENV{CTEST_MAX_PARALLELISM}" STREQUAL "")
  if (nproc GREATER "$ENV{CTEST_MAX_PARALLELISM}")
    set(nproc "$ENV{CTEST_MAX_PARALLELISM}")
  endif ()
endif ()

# Default to a reasonable test timeout.
set(CTEST_TEST_TIMEOUT 100)

set(test_exclusions
  # exclude package generation tests
  "cpack-"
  # https://gitlab.kitware.com/paraview/paraview/-/issues/20061
  "paraview-pvweb-visualizer"

  # Waiting for https://gitlab.kitware.com/paraview/paraview-superbuild/-/merge_requests/842
  "pvweb"
)

string(REPLACE ";" "|" test_exclusions "${test_exclusions}")
if (test_exclusions)
  set(test_exclusions "(${test_exclusions})")
endif ()

ctest_test(APPEND
  PARALLEL_LEVEL "${nproc}"
  RETURN_VALUE test_result
  EXCLUDE "${test_exclusions}"
  OUTPUT_JUNIT "${CTEST_BINARY_DIRECTORY}/junit.xml")

# Need to get a new BUILD_ID for the test phase because the build
# phases runs and submits tests for packaging for the build parts BUILD_ID.
# Currently CDash does not support APPEND to existing parts (BUILD/TEST/etc.)
# for a BUILD_ID.
ctest_submit(PARTS Test
  BUILD_ID test_id)

include("${CMAKE_CURRENT_LIST_DIR}/ctest_annotation.cmake")
if (DEFINED build_id)
  ctest_annotation_report("${CTEST_BINARY_DIRECTORY}/annotations.json"
    "Build Summary" "https://open.cdash.org/build/${build_id}"
    "All Tests"     "https://open.cdash.org/viewTest.php?buildid=${test_id}"
    "Test Failures" "https://open.cdash.org/viewTest.php?onlyfailed&buildid=${test_id}"
    "Tests Not Run" "https://open.cdash.org/viewTest.php?onlynotrun&buildid=${test_id}"
    "Test Passes"   "https://open.cdash.org/viewTest.php?onlypassed&buildid=${test_id}"
  )
endif ()

if (test_result)
  message(FATAL_ERROR
    "Failed to test")
endif ()
