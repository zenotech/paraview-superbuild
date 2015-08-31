cmake_dependent_option(PARAVIEW_WEB_TEST_REMOTE "" OFF
  "paraview_enabled" OFF)

if (PARAVIEW_TEST_REMOTE_WEB)
  include("${CMAKE_CURRENT_LIST_DIR}/paraview.test.web.cmake")
endif ()
