set(CMAKE_OSX_DEPLOYMENT_TARGET 10.13 CACHE STRING "")

set(ENABLE_fides ON CACHE BOOL "")
# pdal requires filesystem which is not available before 10.15
set(ENABLE_pdal OFF CACHE BOOL "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_macos.cmake")
