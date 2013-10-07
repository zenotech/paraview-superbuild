# the name of target operating system
# CMake doesn't have a BGQ platform yet, so still using BGP
SET(CMAKE_SYSTEM_NAME BlueGeneP-static)

# specify the cross compiler
# gnu compiler
find_program(CMAKE_C_COMPILER       powerpc64-bgq-linux-gcc
  /bgsys/drivers/V1R2M0/ppc64/gnu-linux/bin
  /bgsys/drivers/ppcfloor/gnu-linux/bin
)
find_program(CMAKE_CXX_COMPILER     powerpc64-bgq-linux-g++
  /bgsys/drivers/V1R2M0/ppc64/gnu-linux/bin
  /bgsys/drivers/ppcfloor/gnu-linux/bin
)
find_program(CMAKE_Fortran_COMPILER powerpc64-bgq-linux-gfortran
  /bgsys/drivers/V1R2M0/ppc64/gnu-linux/bin
  /bgsys/drivers/ppcfloor/gnu-linux/bin
)

# Make sure MPI_COMPILER wrapper matches the compilers.
# Prefer local machine wrappers to driver wrappers here too.
find_program(MPI_COMPILER NAMES mpicxx
  PATHS
  /usr/local/bin
  /usr/bin
  /soft/compilers/wrappers/gcc/
  /bgsys/drivers/ppcfloor/comm/gcc/bin)

# control search paths that cmake will use to find things to compile
# for the target environment
#set(CMAKE_FIND_ROOT_PATH /bgsys/drivers/ppcfloor/gnu-linux/powerpc64-bgq-linux;/bgsys/drivers/V1R2M0/ppc64/spi/lib;/bgsys/drivers/V1R2M0/ppc64/comm/sys/lib)
set(CMAKE_FIND_ROOT_PATH /bgsys/drivers/ppcfloor/gnu-linux/powerpc64-bgq-linux;/bgsys/drivers/V1R2M0/ppc64/spi;/bgsys/drivers/V1R2M0/ppc64/comm/sys;/bgsys/drivers/V1R2M0/ppc64/gnu-linux/powerpc64-bgq-linux)

# search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
