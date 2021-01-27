# the openvr install rules put the dll into the lib directory
# as opposed to bin where it should be

file(
  INSTALL "${source_location}/lib/win64/openvr_api.lib"
  DESTINATION "${install_location}/lib")
file(
  INSTALL "${source_location}/bin/win64/openvr_api.dll"
  DESTINATION "${install_location}/bin")

file(
  INSTALL "${source_location}/headers/openvr.h"
          "${source_location}/headers/openvr_driver.h"
          "${source_location}/headers/openvr_capi.h"
  DESTINATION "${install_location}/include/openvr")
