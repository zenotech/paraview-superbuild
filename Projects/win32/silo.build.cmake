# INPUT VARIABLES:
# SILO_PATCHES_DIR
# 64BIT_BUILD
# SILO_SOURCE_DIR
# SILO_INSTALL_DIR
# DEVENV_PATH

# set configure environment.
set(ENV{ZLIB_INC_DIR} "\"${SILO_INSTALL_DIR}/include\"")
set(ENV{ZLIB_LIB_DIR} "\"${SILO_INSTALL_DIR}/lib\"")
set(ENV{HDF5_INC_DIR} "\"${SILO_INSTALL_DIR}/include\"")
set(ENV{HDF5_LIB_DIR} "\"${SILO_INSTALL_DIR}/lib\"")

if (64BIT_BUILD)
  set(silo_configuration "DllwithHDF5_Release|x64")
else()
  set(silo_configuration "DllwithHDF5_Release|Win32")
endif()
  
execute_process(
  COMMAND ${DEVENV_PATH} "${SILO_SOURCE_DIR}/SiloWindows/MSVC8/SiloWindows.sln" /Upgrade
  WORKING_DIRECTORY "${SILO_SOURCE_DIR}"
  RESULT_VARIABLE res0)

execute_process(
  COMMAND ${DEVENV_PATH} "${SILO_SOURCE_DIR}/SiloWindows/MSVC8/SiloWindows.sln"
          /build ${silo_configuration} /project pdb_detect
  WORKING_DIRECTORY "${SILO_SOURCE_DIR}"
  RESULT_VARIABLE res1)

execute_process(
  COMMAND ${DEVENV_PATH} "${SILO_SOURCE_DIR}/SiloWindows/MSVC8/SiloWindows.sln"
          /build ${silo_configuration} /project Silo
  WORKING_DIRECTORY "${SILO_SOURCE_DIR}"
  RESULT_VARIABLE res2)

if(NOT ${res0} EQUAL 0 OR NOT ${res1} EQUAL 0 OR NOT ${res2} EQUAL 0)
  message("Silo Errors detected: \n${Silo_OUT}\n${Silo_ERR}")
  message(FATAL_ERROR "Error in build of Silo")
endif()
