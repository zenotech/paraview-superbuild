set(BUILD_SHARED_LIBS_paraview    "OFF" CACHE STRING "")

# Use a static LLVM to not ship extra LLVM libraries/code.
set(llvm_BUILD_SHARED_LIBS        "OFF" CACHE STRING "")

# Disable because `paraview` is static. TTK's plugin directory ends up being
# 1.6GB because it builds shared libraries which each copy VTK or ParaView
# libraries and blowing up the package size.
set(ENABLE_ttk OFF CACHE BOOL "")

set(ENABLE_catalyst                 ON  CACHE BOOL "")

set(ENABLE_mesa                     OFF CACHE BOOL "")
set(ENABLE_nvidiaindex              OFF CACHE BOOL "")
set(ENABLE_qt5                      OFF CACHE BOOL "")
set(ENABLE_qt6                      OFF CACHE BOOL "")
set(ENABLE_libxslt                  OFF CACHE BOOL "")
set(ENABLE_visrtx                   OFF CACHE BOOL "")
set(ENABLE_vrpn                     OFF CACHE BOOL "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_linux_common.cmake")
