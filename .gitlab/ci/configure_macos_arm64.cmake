set(CMAKE_OSX_DEPLOYMENT_TARGET 11.0 CACHE STRING "")

set(qt5_ENABLE_MULTIMEDIA "OFF" CACHE STRING "") # Not installed on macOS CI
set(qt5_ENABLE_WEBENGINE "OFF" CACHE STRING "") # Not installed on macOS CI

include("${CMAKE_CURRENT_LIST_DIR}/configure_macos.cmake")
