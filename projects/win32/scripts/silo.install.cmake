file(
  INSTALL "${source_location}/SiloWindows/MSVC2012/x64/Release/silohdf5.lib"
  DESTINATION "${install_location}/lib")
file(
  INSTALL "${source_location}/SiloWindows/MSVC2012/x64/Release/silohdf5.dll"
  DESTINATION "${install_location}/bin")

# There's a config.h file in this directory that we shouldn't install. That
# causes build problems with other projects.
file(
  INSTALL "${source_location}/SiloWindows/include/silo.h"
          "${source_location}/src/silo/silo_exports.h"
          "${source_location}/SiloWindows/include/siloversion.h"
  DESTINATION "${install_location}/include")
