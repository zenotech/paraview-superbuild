include("${CMAKE_CURRENT_LIST_DIR}/gitlab_ci.cmake")

# Read the files from the build directory.
ctest_read_custom_files("${CTEST_BINARY_DIRECTORY}")

# Pick up from where the configure left off.
ctest_start(APPEND)

include(ProcessorCount)
ProcessorCount(nproc)

#set(test_exclusions
#  # X11-using tests.
#  "display"
#  "UnitTestRead"
#  "DeleteSmtkCell"
#  "discreteImport2dmTest"
#  "pv.OpenExodusFile"
#  "unitQtComponentItem"
#
#  # Python3 support is missing in the ACE3P workflow.
#  # https://gitlab.kitware.com/cmb/simulation-workflows/issues/2
#  "TestSimExportOmega3P_01Py"
#)
#string(REPLACE ";" "|" test_exclusions "${test_exclusions}")
#if (test_exclusions)
#  set(test_exclusions "(${test_exclusions})")
#endif ()

ctest_test(
  PARALLEL_LEVEL "${nproc}"
  RETURN_VALUE test_result
  EXCLUDE "${test_exclusions}")
ctest_submit(PARTS Test)

if (test_result)
  message(FATAL_ERROR
    "Failed to test")
endif ()
