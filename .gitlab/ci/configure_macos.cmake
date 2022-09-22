set(ENABLE_fides ON CACHE BOOL "")
set(ENABLE_openmp OFF CACHE BOOL "")
set(ENABLE_lookingglass ON CACHE BOOL "")
set(ENABLE_threedxwaresdk ON CACHE BOOL "")

# Add the rpath for fortran libraries.
set(_superbuild_fortran_ld_flags "-Wl,-rpath,$ENV{CI_PROJECT_DIR}/.gitlab/gfortran/lib" CACHE STRING "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_common.cmake")
