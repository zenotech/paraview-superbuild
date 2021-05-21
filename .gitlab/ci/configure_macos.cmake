# Add the rpath for fortran libraries.
set(_superbuild_fortran_ld_flags "-Wl,-rpath,$ENV{CI_PROJECT_DIR}/.gitlab/gfortran/lib" CACHE STRING "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_common.cmake")
