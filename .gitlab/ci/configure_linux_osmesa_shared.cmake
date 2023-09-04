set(ENABLE_osmesa                   ON  CACHE BOOL "")
set(ENABLE_catalyst                 ON  CACHE BOOL "")

set(ENABLE_mesa                     OFF CACHE BOOL "")
set(ENABLE_nvidiaindex              OFF CACHE BOOL "")
set(ENABLE_qt5                      OFF CACHE BOOL "")
set(ENABLE_visrtx                   OFF CACHE BOOL "")
set(ENABLE_vrpn                     OFF CACHE BOOL "")

# Use a static LLVM to not ship extra LLVM libraries/code.
set(llvm_BUILD_SHARED_LIBS        "OFF" CACHE STRING "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_common.cmake")
