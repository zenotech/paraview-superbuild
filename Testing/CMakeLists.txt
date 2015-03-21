include(CMakeDependentOption)

cmake_dependent_option(TEST_REMOTE_PARAVIEW_WEB
  "When enabled, tests a live instance of ParaViewWeb." OFF
  BUILD_TESTING OFF)
#cmake_dependent_option(TEST_NIGHTLY_BINARIES
#  "When enabled, tests are run on binaries downloaded from the specified URL rather than generated binaries" OFF
#  BUILD_TESTING OFF)

mark_as_advanced(TEST_REMOTE_PARAVIEW_WEB TEST_NIGHTLY_BINARIES)

if (NOT BUILD_TESTING)
  return()
endif()

set(REMOTE_PVWEB_VISUALIZER_URLS
  http://pvw-test.kitware.com/sbtest
  http://pvw.kitware.com/sbtest
  http://paraviewweb.kitware.com/sbtest
  CACHE STRING "A list of urls against which to run a simple Web Visualizer test.")
set(REMOTE_PVWEB_TEST_BROWSER firefox
  CACHE STRING "Which browser to use during testing, either chrome or firefox")
mark_as_advanced(REMOTE_PVWEB_VISUALIZER_URLS REMOTE_PVWEB_TEST_BROWSER)

include(${CMAKE_CURRENT_SOURCE_DIR}/tests.cmake)
