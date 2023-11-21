set(BUILD_SHARED_LIBS_paraview    "OFF" CACHE STRING "")

# Disable because `paraview` is static. TTK's plugin directory ends up being
# 1.6GB because it builds shared libraries which each copy VTK or ParaView
# libraries and blowing up the package size.
set(ENABLE_ttk OFF CACHE BOOL "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_linux_osmesa_shared.cmake")
