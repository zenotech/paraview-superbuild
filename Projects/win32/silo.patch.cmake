# INPUT VARIABLES:
# SILO_PATCHES_DIR
# 64BIT_BUILD
# SILO_SOURCE_DIR
# SILO_INSTALL_DIR

# set configure environment.
set(ENV{ZLIB_INC_DIR} "\"${SILO_INSTALL_DIR}/include\"")
set(ENV{ZLIB_LIB_DIR} "\"${SILO_INSTALL_DIR}/lib\"")
set(ENV{HDF5_INC_DIR} "\"${SILO_INSTALL_DIR}/include\"")
set(ENV{HDF5_LIB_DIR} "\"${SILO_INSTALL_DIR}/lib\"")


execute_process(
  # we have copy in our own versions of these files which have x64
  # configurations added to them.
  COMMAND ${CMAKE_COMMAND} -E copy_if_different 
          "${SILO_PATCHES_DIR}/copysilo.bat.in"
          "${SILO_SOURCE_DIR}/SiloWindows/copysilo.bat"
  # this file contains quotation patches to handle executing pdb_detect.exe when
  # it in a directory with spaces.
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          "${SILO_PATCHES_DIR}/pdb_detect.vcproj"
          "${SILO_SOURCE_DIR}/SiloWindows/MSVC8/pdb_detect/pdb_detect.vcproj"

  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          "${SILO_PATCHES_DIR}/silex.vcproj"
          "${SILO_SOURCE_DIR}/SiloWindows/MSVC8/silex.vcproj"

  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          "${SILO_PATCHES_DIR}/Silo.vcproj"
          "${SILO_SOURCE_DIR}/SiloWindows/MSVC8/Silo.vcproj"

  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          "${SILO_PATCHES_DIR}/SiloWindows.sln"
          "${SILO_SOURCE_DIR}/SiloWindows/MSVC8/SiloWindows.sln")
