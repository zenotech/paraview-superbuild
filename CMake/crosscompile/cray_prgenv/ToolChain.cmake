# The name of the target operating system
set(CMAKE_SYSTEM_NAME CrayLinuxEnvironment)

if(DEFINED ENV{ASYNCPE_DIR})
  set(COMP_DIR $ENV{ASYNCPE_DIR})
elseif(DEFINED ENV{CRAYPE_DIR})
  set(COMP_DIR $ENV{CRAYPE_DIR})
else()
  message(FATAL_ERROR "Unable to determine compiler dir")
endif()

# Set the compilers
set(CMAKE_C_COMPILER       ${COMP_DIR}/bin/cc)
set(CMAKE_CXX_COMPILER     ${COMP_DIR}/bin/CC)
set(CMAKE_Fortran_COMPILER ${COMP_DIR}/bin/ftn)
