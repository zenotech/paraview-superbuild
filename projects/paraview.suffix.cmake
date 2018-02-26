# Set suffix to be used for generating archives. This ensures that the package
# files have decent names that we can directly upload to the website.
set(package_suffix_items)
if (qt5_enabled)
  list(APPEND package_suffix_items
    Qt5)
endif ()
if (mpi_enabled)
  list(APPEND package_suffix_items
    MPI)
endif ()
if (APPLE)
  list(APPEND package_suffix_items
    "OSX${CMAKE_OSX_DEPLOYMENT_TARGET}")
else ()
  list(APPEND package_suffix_items
    "${CMAKE_SYSTEM_NAME}")
endif ()
# XXX(package): Temporary as the transition to the CentOS6 builder takes place.
if (ENV{HOSTNAME} STREQUAL "pvbinsdash")
  list(APPEND package_suffix_items
    "el6")
endif ()
if (superbuild_is_64bit)
  list(APPEND package_suffix_items
    "64bit")
else ()
  list(APPEND package_suffix_items
    "32bit")
endif()

string(REPLACE ";" "-" package_suffix_default "${package_suffix_items}")

# PARAVIEW_PACKAGE_SUFFIX: A string that can be set to the suffix you want to
# use for all the generated packages. By default, it is determined by the
# features enabled.
set(PARAVIEW_PACKAGE_SUFFIX "<default>"
  CACHE STRING "String to use as a suffix for generated packages")
mark_as_advanced(PARAVIEW_PACKAGE_SUFFIX)

if (NOT PARAVIEW_PACKAGE_SUFFIX OR PARAVIEW_PACKAGE_SUFFIX STREQUAL "<default>")
  set(PARAVIEW_PACKAGE_SUFFIX "${package_suffix_default}")
elseif (NOT PARAVIEW_PACKAGE_SUFFIX STREQUAL package_suffix_default)
  message(WARNING "The suffix for the package (${PARAVIEW_PACKAGE_SUFFIX}) does not "
                  "match the suggested suffix based on build options "
                  "(${package_suffix_default}). Set it to '<default>' or "
                  "an empty string to use the default suffix. Using the "
                  "provided suffix.")
endif ()
