# the name of target operating system
# CMake doesn't have a BGQ platform yet, so still using BGP
SET(CMAKE_SYSTEM_NAME BlueGeneP-static)

# specify the cross compiler
# IBM xlc compilers
find_program(CMAKE_C_COMPILER       bgxlc    ${BGP_XL_COMPILER_SEARCH_PATHS}
/soft/apps/ibmcmp-feb2013/vac/bg/12.1/bin/bgxlc)
find_program(CMAKE_CXX_COMPILER     bgxlC    ${BGP_XL_COMPILER_SEARCH_PATHS}
/soft/apps/ibmcmp-feb2013/vac/bg/12.1/bin/bgxlC)
find_program(CMAKE_Fortran_COMPILER bgxlf90  ${BGP_XL_COMPILER_SEARCH_PATHS}
/soft/apps/ibmcmp-feb2013/vac/bg/12.1/bin/bgf90)

# Make sure MPI_COMPILER wrapper matches the compilers.
# Prefer local machine wrappers to driver wrappers here too.
find_program(MPI_COMPILER NAMES mpixlcxx mpixlc++ mpixlC mpixlc
  PATHS
  /usr/local/bin
  /usr/bin
  /bgsys/drivers/ppcfloor/comm/xl/bin)

# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
