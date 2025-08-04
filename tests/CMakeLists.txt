option(enable_paraview_tests "Enable ParaView tests" ON)

if(enable_paraview_tests)
  if (paraview_enabled)
    include("${CMAKE_CURRENT_LIST_DIR}/paraview.test.cmake")
  endif ()

  if (paraviewsdk_enabled)
    include("${CMAKE_CURRENT_LIST_DIR}/paraviewsdk.test.cmake")
  endif ()
endif ()

