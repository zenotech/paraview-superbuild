# Add the rpath for fortran libraries.
set(_superbuild_fortran_ld_flags "-Wl,-rpath,$ENV{CI_PROJECT_DIR}/.gitlab/gfortran/lib" CACHE STRING "")

# Use the new boost for gitlab-ci.
set(paraview_superbuild_new_boost ON CACHE BOOL "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_common.cmake")
