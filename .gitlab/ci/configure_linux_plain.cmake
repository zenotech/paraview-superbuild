set(ENABLE_cdi ON CACHE BOOL "")
set(SUPPRESS_cdi_OUTPUT ON CACHE BOOL "")
set(ENABLE_catalyst ON  CACHE BOOL "")
set(ENABLE_lookingglass ON  CACHE BOOL "")
set(ENABLE_fides ON CACHE BOOL "")
set(ENABLE_nvidiaoptix ON CACHE BOOL "")
set(ENABLE_visrtx ON CACHE BOOL "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_common.cmake")
