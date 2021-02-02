set(CMAKE_OSX_DEPLOYMENT_TARGET 10.13 CACHE STRING "")

set(ENABLE_lookingglass ON CACHE BOOL "")
set(ENABLE_fides ON CACHE BOOL "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_macos.cmake")
