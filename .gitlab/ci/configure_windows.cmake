set(PACKAGE_SYSTEM_QT ON CACHE BOOL "")

set(ENABLE_lookingglass ON  CACHE BOOL "")
set(ENABLE_nvidiaindex ON CACHE BOOL "")
set(ENABLE_openimagedenoise OFF CACHE BOOL "")
set(ENABLE_openvr ON CACHE BOOL "")
# set(ENABLE_threedxwaresdk ON CACHE BOOL "")
set(ENABLE_zeromq ON CACHE BOOL "")
set(ENABLE_visrtx ON CACHE BOOL "")
set(ENABLE_vortexfinder2 OFF CACHE BOOL "")
set(ENABLE_nvidiaoptix ON CACHE BOOL "")

file(TO_CMAKE_PATH "$ENV{CI_PROJECT_DIR}/.gitlab/qt" cmake_qt_prefix)
set(CMAKE_PREFIX_PATH "${cmake_qt_prefix}" CACHE STRING "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_common.cmake")
