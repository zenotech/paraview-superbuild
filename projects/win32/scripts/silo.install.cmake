if (superbuild_is_64bit)
  set(silo_bin_location SiloWindows/MSVC9/x64/Release)
else ()
  set(silo_bin_location SiloWindows/MSVC9/Win32/Release)
endif ()

configure_file(
  "${source_location}/${silo_bin_location}/silohdf5.lib"
  "${install_location}/lib/silohdf5.lib"
  COPYONLY)
configure_file(
  "${source_location}/${silo_bin_location}/silohdf5.dll"
  "${install_location}/bin/silohdf5.dll"
  COPYONLY)

# There's a config.h file in this directory that we shouldn't install. That
# causes build problems with other projects.
configure_file(
  "${source_location}/SiloWindows/include/silo.h"
  "${install_location}/include/silo.h"
  COPYONLY)
configure_file(
  "${source_location}/SiloWindows/include/siloversion.h"
  "${install_location}/include/siloversion.h"
  COPYONLY)
