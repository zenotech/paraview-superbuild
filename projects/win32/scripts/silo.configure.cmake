# set configure environment.
set(ENV{ZLIB_INC_DIR} "${install_location}/include")
set(ENV{ZLIB_LIB_DIR} "${install_location}/lib")
set(ENV{HDF5_INC_DIR} "${install_location}/include")
set(ENV{HDF5_LIB_DIR} "${install_location}/lib")

execute_process(
  COMMAND copysilo.bat
  WORKING_DIRECTORY "${source_location}/SiloWindows"
  RESULT_VARIABLE res)

if (NOT res)
  message(STATUS "Silo configured successfully")
else ()
  message(FATAL_ERROR "Silo configuration failed.")
endif()
