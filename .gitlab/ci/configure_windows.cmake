set(PACKAGE_SYSTEM_QT ON CACHE BOOL "")

set(ENABLE_catalyst ON CACHE BOOL "")
set(ENABLE_lookingglass ON  CACHE BOOL "")
set(ENABLE_nvidiaindex ON CACHE BOOL "")
set(ENABLE_openmp OFF CACHE BOOL "")
set(ENABLE_openimagedenoise OFF CACHE BOOL "")
set(ENABLE_openvr ON CACHE BOOL "")
set(ENABLE_openxrremoting ON CACHE BOOL "")
set(ENABLE_openxrsdk ON CACHE BOOL "")
set(ENABLE_paraviewtranslations ON CACHE BOOL "")
set(ENABLE_threedxwaresdk ON CACHE BOOL "")
set(ENABLE_zeromq ON CACHE BOOL "")
set(ENABLE_visrtx ON CACHE BOOL "")
set(ENABLE_vortexfinder2 OFF CACHE BOOL "")
set(ENABLE_nvidiaoptix ON CACHE BOOL "")
set(ENABLE_zspace ON CACHE BOOL "")

set(qt5_ENABLE_WEBENGINE "OFF" CACHE STRING "") # Not installed on macOS CI

file(TO_CMAKE_PATH "$ENV{CI_PROJECT_DIR}/.gitlab/qt" cmake_qt_prefix)
set(CMAKE_PREFIX_PATH "${cmake_qt_prefix}" CACHE STRING "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_common.cmake")
