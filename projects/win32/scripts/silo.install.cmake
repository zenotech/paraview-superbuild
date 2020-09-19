if (superbuild_is_64bit)
  set(silo_bin_location SiloWindows/MSVC2012/x64/Release)
else ()
  set(silo_bin_location SiloWindows/MSVC2012/Win32/Release)
endif ()

file(
  INSTALL "${source_location}/${silo_bin_location}/silohdf5.lib"
  DESTINATION "${install_location}/lib")
file(
  INSTALL "${source_location}/${silo_bin_location}/silohdf5.dll"
  DESTINATION "${install_location}/bin")

# There's a config.h file in this directory that we shouldn't install. That
# causes build problems with other projects.
file(
  INSTALL "${source_location}/SiloWindows/include/silo.h"
          "${source_location}/src/silo/silo_exports.h"
          "${source_location}/SiloWindows/include/siloversion.h"
  DESTINATION "${install_location}/include")
