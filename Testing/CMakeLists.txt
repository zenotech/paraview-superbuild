#cmake_dependent_option(TEST_NIGHTLY_BINARIES
#  "When enabled, tests are run on binaries downloaded from the specified URL rather than generated binaries" OFF
#  BUILD_TESTING OFF)

mark_as_advanced(TEST_NIGHTLY_BINARIES)

if (NOT BUILD_TESTING)
  return()
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/tests.cmake)
