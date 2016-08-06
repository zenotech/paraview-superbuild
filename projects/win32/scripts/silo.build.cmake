if (superbuild_is_64bit)
  set(ENV{ZLIB_INC_DIR} "\"${install_location}/include\"")
  set(ENV{ZLIB_LIB_DIR_X64} "\"${install_location}/lib\"")
  set(ENV{HDF5_INC_DIR_X64} "\"${install_location}/include\"")
  set(ENV{HDF5_LIB_DIR_X64} "\"${install_location}/lib\"")
  set(silo_configuration "Release|x64")
else ()
  set(ENV{ZLIB_INC_DIR} "\"${install_location}/include\"")
  set(ENV{ZLIB_LIB_DIR} "\"${install_location}/lib\"")
  set(ENV{HDF5_INC_DIR} "\"${install_location}/include\"")
  set(ENV{HDF5_LIB_DIR} "\"${install_location}/lib\"")
  set(silo_configuration "Release|Win32")
endif ()

execute_process(
  COMMAND ${DEVENV_PATH}
          "${source_location}/SiloWindows/MSVC9/SiloWindows.sln"
          /Upgrade
  WORKING_DIRECTORY "${source_location}"
  RESULT_VARIABLE res_upgrade)

execute_process(
  COMMAND ${DEVENV_PATH}
          "${source_location}/SiloWindows/MSVC9/SiloWindows.sln"
          /build ${silo_configuration}
          /project Silo
  WORKING_DIRECTORY "${source_location}"
  RESULT_VARIABLE res_build)

if (res_upgrade OR res_build)
  message(FATAL_ERROR "Error building Silo!")
endif ()
