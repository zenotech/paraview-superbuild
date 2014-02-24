# INPUT VARIABLES:
# SILO_PATCHES_DIR
# 64BIT_BUILD
# SILO_SOURCE_DIR
# SILO_INSTALL_DIR
# DEVENV_PATH

if (64BIT_BUILD)
  set(ENV{ZLIB_INC_DIR} "\"${SILO_INSTALL_DIR}/include\"")
  set(ENV{ZLIB_LIB_DIR_X64} "\"${SILO_INSTALL_DIR}/lib\"")
  set(ENV{HDF5_INC_DIR_X64} "\"${SILO_INSTALL_DIR}/include\"")
  set(ENV{HDF5_LIB_DIR_X64} "\"${SILO_INSTALL_DIR}/lib\"")
  set(silo_configuration "Release|x64")
else()
  set(ENV{ZLIB_INC_DIR} "\"${SILO_INSTALL_DIR}/include\"")
  set(ENV{ZLIB_LIB_DIR} "\"${SILO_INSTALL_DIR}/lib\"")
  set(ENV{HDF5_INC_DIR} "\"${SILO_INSTALL_DIR}/include\"")
  set(ENV{HDF5_LIB_DIR} "\"${SILO_INSTALL_DIR}/lib\"")
  set(silo_configuration "Release|Win32")
endif()
  
execute_process(
  COMMAND ${DEVENV_PATH} "${SILO_SOURCE_DIR}/SiloWindows/MSVC9/SiloWindows.sln" /Upgrade
  WORKING_DIRECTORY "${SILO_SOURCE_DIR}"
  RESULT_VARIABLE res0)

execute_process(
  COMMAND ${DEVENV_PATH} "${SILO_SOURCE_DIR}/SiloWindows/MSVC9/SiloWindows.sln"
          /build ${silo_configuration} /project Silo
  WORKING_DIRECTORY "${SILO_SOURCE_DIR}"
  RESULT_VARIABLE res2)

if(NOT ${res0} EQUAL 0 OR NOT ${res2} EQUAL 0)
  message("Silo Errors detected: \n${Silo_OUT}\n${Silo_ERR}")
  message(FATAL_ERROR "Error in build of Silo")
endif()
