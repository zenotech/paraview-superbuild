set(ENABLE_egl                        ON  CACHE BOOL "")

set(ENABLE_mesa                       OFF CACHE BOOL "")
set(ENABLE_osmesa                     OFF CACHE BOOL "")
set(ENABLE_qt5                        OFF CACHE BOOL "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_common.cmake")
