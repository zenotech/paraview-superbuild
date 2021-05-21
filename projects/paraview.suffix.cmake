# Set suffix to be used for generating archives. This ensures that the package
# files have decent names that we can directly upload to the website.
set(package_suffix_items)
if (osmesa_enabled)
  list(APPEND package_suffix_items
    "osmesa")
endif()
if (egl_enabled)
  list(APPEND package_suffix_items
    "egl")
endif()
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

if (python_enabled)
  list(APPEND package_suffix_items
    "Python${superbuild_python_version}")
endif ()

# On Windows, we put add MSVC compiler version in the package name
if (WIN32 AND MSVC)
  if (MSVC_VERSION LESS 1800) # 1800 == VS2013
    message(FATAL_ERROR "Visual Studio 2013 or newer is required.")
  elseif (MSVC_VERSION LESS 1900) # 1900 == VS2015
    list(APPEND package_suffix_items
      "msvc2013")
  elseif (MSVC_VERSION LESS 1910) # 1910 == VS2017
    list(APPEND package_suffix_items
      "msvc2015")
  else()
    list(APPEND package_suffix_items
      "msvc2017")
  endif()
endif()

list(APPEND package_suffix_items
  "${CMAKE_SYSTEM_PROCESSOR}")

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
