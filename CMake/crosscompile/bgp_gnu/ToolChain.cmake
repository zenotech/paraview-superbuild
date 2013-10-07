# the name of the target operating system
set(CMAKE_SYSTEM_NAME BlueGeneP-static)

# Set search paths to prefer local, admin-installed wrappers for the BG backend compilers
set(BGP_GNU_COMPILER_SEARCH_PATHS /bgsys/drivers/ppcfloor/comm/bin/)

# GNU C Compilers
find_program(CMAKE_C_COMPILER       mpicc  ${BGP_GNU_COMPILER_SEARCH_PATHS})
find_program(CMAKE_CXX_COMPILER     mpicxx ${BGP_GNU_COMPILER_SEARCH_PATHS})
find_program(CMAKE_Fortran_COMPILER mpif90 ${BGP_GNU_COMPILER_SEARCH_PATHS})
