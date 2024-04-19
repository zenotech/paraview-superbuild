set(CMAKE_OSX_DEPLOYMENT_TARGET 10.15 CACHE STRING "")

set(ENABLE_fides ON CACHE BOOL "")

set(qt5_ENABLE_WEBENGINE "OFF" CACHE STRING "") # Not installed on macOS CI

include("${CMAKE_CURRENT_LIST_DIR}/configure_macos.cmake")
