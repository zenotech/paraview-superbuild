# Install headers
file(INSTALL
  "${source_location}/include/"
  DESTINATION "${install_location}/include")

# Install libraries
file(INSTALL
  "${source_location}/${libdir}/"
  DESTINATION "${install_location}/${libdest}"
  FILES_MATCHING
    PATTERN "*${libsuffix}")
