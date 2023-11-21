set(ENABLE_mpi ON CACHE BOOL "")
set(ENABLE_pythonmpi4py ON CACHE BOOL "")
# https://github.com/ospray/module_mpi/issues/2
set(ENABLE_ospraymodulempi OFF CACHE BOOL "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_windows.cmake")
