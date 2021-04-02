include("${CMAKE_CURRENT_LIST_DIR}/gitlab_ci.cmake")

# Read the files from the build directory.
ctest_read_custom_files("${CTEST_BINARY_DIRECTORY}")

# Pick up from where the configure left off.
ctest_start(APPEND)

include(ProcessorCount)
ProcessorCount(nproc)

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

# Windows seems to have some spurious error that isn't "seen" by Process
# Monitor or other debugging tools. Just try tests until they pass.
set(retry_args)
if ("$ENV{CMAKE_CONFIGURATION}" MATCHES "windows")
  list(APPEND retry_args
    REPEAT UNTIL_PASS:3)
endif ()

ctest_test(APPEND
  PARALLEL_LEVEL "${nproc}"
  RETURN_VALUE test_result
  EXCLUDE "${test_exclusions}"
  ${retry_args})
ctest_submit(PARTS Test)

if (test_result)
  message(FATAL_ERROR
    "Failed to test")
endif ()
