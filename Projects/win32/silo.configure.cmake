# INPUT VARIABLES:
# SILO_PATCHES_DIR
# 64BIT_BUILD
# SILO_SOURCE_DIR
# SILO_INSTALL_DIR

# set configure environment.
set(ENV{ZLIB_INC_DIR} "${SILO_INSTALL_DIR}/include")
set(ENV{ZLIB_LIB_DIR} "${SILO_INSTALL_DIR}/lib")
set(ENV{HDF5_INC_DIR} "${SILO_INSTALL_DIR}/include")
set(ENV{HDF5_LIB_DIR} "${SILO_INSTALL_DIR}/lib")
execute_process(
  COMMAND copysilo.bat
  WORKING_DIRECTORY "${SILO_SOURCE_DIR}/SiloWindows"
  RESULT_VARIABLE res)

if ("${res}" STREQUAL "0")
  message(STATUS "Silo configured successfully")
else ()
  message(STATUS "Silo configuration failed.")
endif()
