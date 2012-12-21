# the name of the target operating system
set(CMAKE_SYSTEM_NAME BlueGeneP-static)

# Set search paths to prefer local, admin-installed wrappers for the BG backend compilers
set(BGP_XL_COMPILER_SEARCH_PATHS /usr/local/bin /usr/bin)

# GNU C Compilers
find_program(CMAKE_C_COMPILER       bgxlc    ${BGP_XL_COMPILER_SEARCH_PATHS}
/soft/apps/ibmcmp-aug2012/vac/bg/9.0/bin/bgxlc)
find_program(CMAKE_CXX_COMPILER     bgxlC    ${BGP_XL_COMPILER_SEARCH_PATHS} 
/soft/apps/ibmcmp-aug2012/vacpp/bg/9.0/bin/bgxlC)
find_program(CMAKE_Fortran_COMPILER bgxlf90  ${BGP_XL_COMPILER_SEARCH_PATHS} 
/soft/apps/ibmcmp-aug2012/xlf/bg/11.1/bin/bgf90)

# Make sure MPI_COMPILER wrapper matches the compilers.  
# Prefer local machine wrappers to driver wrappers here too.
find_program(MPI_COMPILER NAMES mpixlcxx mpixlc++ mpixlC mpixlc
  PATHS 
  /usr/local/bin
  /usr/bin
  /bgsys/drivers/ppcfloor/comm/bin
  /bgsys/drivers/ppcfloor/comm/default/bin)
