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
  # this file contains quotation patches to handle executing pdb_detect.exe when
  # it in a directory with spaces and remove perl.exe
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          "${SILO_PATCHES_DIR}/pdb_detect.vcproj"
          "${SILO_SOURCE_DIR}/SiloWindows/MSVC9/pdb_detect/pdb_detect.vcproj"

  # use zlib instead of zlib1
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          "${SILO_PATCHES_DIR}/Silo.vcproj"
          "${SILO_SOURCE_DIR}/SiloWindows/MSVC9/Silo.vcproj"
)
