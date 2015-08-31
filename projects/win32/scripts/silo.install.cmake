# INPUT VARIABLES:
# 64bit_build
# source_dir
# install_dir
if (64bit_build)
  set(silo_bin_dir SiloWindows/MSVC9/x64/Release)
else ()
  set(silo_bin_dir SiloWindows/MSVC9/Win32/Release)
endif ()

configure_file(
  "${source_dir}/${silo_bin_dir}/silohdf5.lib"
  "${install_dir}/lib/silohdf5.lib"
  COPYONLY)
configure_file(
  "${source_dir}/${silo_bin_dir}/silohdf5.dll"
  "${install_dir}/bin/silohdf5.dll"
  COPYONLY)

# There's a config.h file in this directory that we shouldn't install. That
# causes build problems with other projects.
configure_file(
  "${source_dir}/SiloWindows/include/silo.h"
  "${install_dir}/include/silo.h"
  COPYONLY)
configure_file(
  "${source_dir}/SiloWindows/include/siloversion.h"
  "${install_dir}/include/siloversion.h"
  COPYONLY)
