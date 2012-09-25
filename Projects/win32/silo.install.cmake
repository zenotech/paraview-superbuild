# INPUT VARIABLES:
# SILO_PATCHES_DIR
# 64BIT_BUILD
# SILO_SOURCE_DIR
# SILO_INSTALL_DIR
if (64BIT_BUILD)
  set(silo_bin_dir SiloWindows/MSVC8/x64/DllwithHDF5_Release)
else()
  set(silo_bin_dir SiloWindows/MSVC8/Win32/DllwithHDF5_Release)
endif()


execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          "${SILO_SOURCE_DIR}/${silo_bin_dir}/silohdf5.lib"
          "${SILO_INSTALL_DIR}/lib/silohdf5.lib"

  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          "${SILO_SOURCE_DIR}/${silo_bin_dir}/silohdf5.dll"
          "${SILO_INSTALL_DIR}/bin/silohdf5.dll"

  COMMAND ${CMAKE_COMMAND} -E copy_directory
          "${SILO_SOURCE_DIR}/SiloWindows/include"
          "${SILO_INSTALL_DIR}/include"
  )
