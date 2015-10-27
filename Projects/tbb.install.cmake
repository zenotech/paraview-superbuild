# Install headers
file(INSTALL
  "${source_location}/include/"
  DESTINATION "${install_location}/include"
  PATTERN "index.html" EXCLUDE)

# Install libraries
file(INSTALL
  "${source_location}/${libdir}/"
  DESTINATION "${install_location}/lib"
  FILES_MATCHING
    PATTERN "${libprefix}tbb${libsuffix}"
    PATTERN "${libprefix}tbbmalloc${libsuffix}")

if (WIN32)
  # Install DLLs
  string(REPLACE "lib" "bin" bindir "${libdir}")
  file(INSTALL
    "${source_location}/${bindir}/${libprefix}tbb${libsuffixshared}"
    "${source_location}/${bindir}/${libprefix}tbbmalloc${libsuffixshared}"
    DESTINATION "${install_location}/bin")
endif ()
