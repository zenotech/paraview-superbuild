cmake_minimum_required(VERSION 3.5)

project(ParaViewSuperBuild)

option(TRUST_SVN_CERTIFICATES_AUTOMATICALLY
  "Trust SVN certificates automatically" ON)
mark_as_advanced(TRUST_SVN_CERTIFICATES_AUTOMATICALLY)

#-----------------------------------------------------------------------------
## Top-level options. These must be limited to a commonly used subset with
## default values being used for building ParaView binaries.
#option(PV_COMMAND_LINE_TOOLS_ONLY
#  "Turn this ON to build command lines tools alone." OFF)

if (WIN32)
  if ( (NOT "${CMAKE_GENERATOR}" MATCHES "^NMake.*$") OR
       (NOT "${CMAKE_GENERATOR}" MATCHES "^Visual Studio.*$"))
  # not use VS environment. We need to be pointed to nmake and devenv paths
  # since they are needed when building tools (qt, python, etc.)
    find_program(DEVENV_PATH devenv)
    mark_as_advanced(DEVENV_PATH)
  endif()
endif()

option(USE_NONFREE_COMPONENTS "Enable the non-free parts of the superbuild" OFF)
mark_as_advanced(USE_NONFREE_COMPONENTS)

if (ENABLE_qt AND NOT ENABLE_qt4 AND NOT ENABLE_qt5)
  message(FATAL_ERROR "Qt is enabled, but no version is specified. "
          "Please enable either Qt4 (recommended) or Qt5.")
endif ()

# Include all optional projects. These are the ones user can pick and choose.
# Some of these allow using system libraries too.
if (CROSS_BUILD_STAGE STREQUAL "CROSS")
  #include(crossnumpy)
  include(python)
  include(mesa)
  include(paraview)
  include(paraviewsdk)
elseif(CROSS_BUILD_STAGE STREQUAL "TOOLS")
  include(boost)
  include(bzip2)
  include(png)
  include(zlib)
  include(python)
  include(paraview)
  include(portfwd)
else()
  include(boost)
  include(bzip2)
  include(cgns)
  include(freetype)
  include(hdf5)
  include(ispc)
  include(netcdf)
  include(libxml2)
  include(manta)
  include(matplotlib)
  include(mpi)
  include(numpy)
  include(ospray)
  include(png)
  include(python)
  include(qt4)
  include(qt5)
  include(silo)
  include(szip)
  include(tbb)
  include(visitbridge)
  include(vortexfinder2)
  include(vrpn)
  include(xdmf3)
  include(zlib)
  if(CMAKE_Fortran_COMPILER)
    # both of these packages require a Fortran compiler to build so we
    # only present them to the user if we have one.
    include(lapack)
  endif()

  if (UNIX)
    # Supported on Linux/Mac
    include(adios)
    include(mxml)
    include(ffmpeg)
  endif()

  if (UNIX AND NOT APPLE)
    include(portfwd)
    include(fontconfig)
    include(llvm)
    include(mesa)
    include(osmesa)
    include(egl)
    include(catalyst)
  endif()

  # Build CosmoTools on Linux and OS X
  if (UNIX AND USE_NONFREE_COMPONENTS)
    include(qhull)
    include(diy)
    include(genericio)
    include(cosmotools)
  endif()

  include(paraviewusersguide)
  include(paraviewtutorial)
  include(paraviewgettingstartedguide)
  include(paraviewtutorialdata)

  # REMEMBER to tell VTK/ParaView to use VTK_SYSTEM_* for the
  # libraries we've built here.
  include(paraview)
  if (USE_NONFREE_COMPONENTS)
    include(vistrails)
    include(acusolve)
  endif ()

  # paraview.sdk is a module that is used install the ParaView SDK.
  # Simply enabling this module will result in the ParaView SDK to be
  # installed by "make install". Note that this is not always supported.
  include(paraviewsdk OPTIONAL)
endif()

if (${ENABLE_ospray})
  #Turn ON C++1
  if (UNIX AND NOT APPLE)
    set(cxxflags
        "${cxxflags} -std=c++11 -Wno-literal-suffix -Wno-error=narrowing -Wno-narrowing")
  endif ()
  if (APPLE)
    set(cxxflags
        "${cxxflags} -std=c++11 -stdlib=libc++ -Wno-error=c++11-narrowing -D_DARWIN_C_SOURCE")
    set(ldflags
        "${ldflags} -stdlib=libc++")
  endif ()
endif()

#-------------------------------------------------------------------------
# Add any additional project that the user wants
set(PV_EXTERNAL_PROJECTS "" CACHE STRING
    "Provide the list of Projects that ParaView should additionally depends on")
mark_as_advanced(PV_EXTERNAL_PROJECTS)

# Include all additional external projects
# Its their responsibility to check the system and provide empty target if the
# platform is not supported
foreach(external_project IN ITEMS ${PV_EXTERNAL_PROJECTS})
  include(${external_project})
  set(ENABLE_${external_project} ON CACHE BOOL "" FORCE)
endforeach()


process_dependencies()

#-------------------------------------------------------------------------
# Some sanity checks.
# Sanity check: Cannot have EGL and qt enabled at the same time.
if (egl_ENABLED AND (qt4_ENABLED OR qt5_ENABLED))
  message(SEND_ERROR "Cannot enable EGL and Qt at the same time.")
endif()
# Sanity check: Cannot have egl and mesa at the same time.
if (egl_ENABLED AND mesa_ENABLED)
  message(SEND_ERROR "Cannot enable EGL and Mesa at the same time.")
endif()
# Sanity check: Must use OpenGL2 backed with egl
if (egl_ENABLED AND NOT ${PARAVIEW_RENDERING_BACKEND} STREQUAL "OpenGL2")
  message(SEND_ERROR "Cannot enable EGL and OSMesa at the same time.")
endif()
# Sanity check: Cannot have egl and osmesa at the same time.
if (egl_ENABLED AND osmesa_ENABLED)
  message(SEND_ERROR "Cannot enable EGL and OSMesa at the same time.")
endif()
# Sanity check: Cannot have osmesa and qt enabled at the same time.
if (osmesa_ENABLED AND (qt4_ENABLED OR qt5_ENABLED))
  message(SEND_ERROR "Cannot enable OSMesa and Qt at the same time.")
endif()
# Sanity check: Cannot have osmesa and mesa at the same time.
if (osmesa_ENABLED AND mesa_ENABLED)
  message(SEND_ERROR "Cannot enable OSMesa and Mesa at the same time.")
endif()
# Sanity check: Cannot have catalyst and paraview enabled at the same time.
if (paraview_ENABLED AND catalyst_ENABLED)
  message(SEND_ERROR "Cannot enable ParaView and Catalyst at the same time.")
endif()
#-------------------------------------------------------------------------

# Set suffix to be used for generating archives. This ensures that the package
# files have decent names that we can directly upload to the website.
set(package_suffix_items)
if (qt4_ENABLED)
  list(APPEND package_suffix_items
    Qt4)
endif ()
if (paraview_ENABLED AND PARAVIEW_RENDERING_BACKEND STREQUAL "OpenGL2")
  list(APPEND package_suffix_items
    OpenGL2)
endif ()
if (mpi_ENABLED)
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
if (64bit_build)
  list(APPEND package_suffix_items
    "64bit")
else ()
  list(APPEND package_suffix_items
    "32bit")
endif()

string(REPLACE ";" "-" package_suffix_default "${package_suffix_items}")

# PACKAGE_SUFFIX: A string that can be set to the suffix you want to use for all
# the generated packages. By default, its set to
# ${CMAKE_SYSTEM_NAME}-{64|32}bit.
set (PACKAGE_SUFFIX "<default>"
  CACHE STRING "String to use as a suffix for generated packages")
mark_as_advanced(PACKAGE_SUFFIX)

if (NOT PACKAGE_SUFFIX OR PACKAGE_SUFFIX STREQUAL "<default>")
  set(PACKAGE_SUFFIX "${package_suffix_default}")
elseif (NOT PACKAGE_SUFFIX STREQUAL package_suffix_default)
  message(WARNING "The suffix for the package (${PACKAGE_SUFFIX}) does not "
                  "match the suggested suffix based on build options "
                  "(${package_suffix_default}). Set it to '<default>' or "
                  "an empty string to use the default suffix. Using the "
                  "provided suffix.")
endif ()

file(WRITE "${CMAKE_BINARY_DIR}/paraview_version.cmake"
"set(bundle_suffix \"${pv_version_long}-${PACKAGE_SUFFIX}\")
")

if (paraview_ENABLED)
  include(paraview.bundle OPTIONAL)
endif()

if (catalyst_ENABLED)
  include(catalyst.bundle OPTIONAL)
endif()

add_subdirectory(Testing)

#------------------------------------------------------------------------------
# Test to check install tree for paraviewsdk
#------------------------------------------------------------------------------
if (BUILD_TESTING AND paraviewsdk_ENABLED)
  add_test ( NAME TestParaViewSDKInstall
    COMMAND ${CMAKE_COMMAND}
    -DPARAVIEW_BINARY_DIR:PATH=${SuperBuild_BINARY_DIR}
    -DPARAVIEW_INSTALL_DIR:PATH=${CMAKE_INSTALL_PREFIX}
    -DPARAVIEW_SOURCE_DIR:PATH=${SuperBuild_BINARY_DIR}/paraview/src/paraview
    -DPARAVIEW_TEST_DIR:PATH=${SuperBuild_BINARY_DIR}/Testing/Temporary
    -DPARAVIEW_VERSION:STRING=${pv_version}
    -P ${SuperBuild_CMAKE_DIR}/ParaViewSDKTestInstall.cmake)
  set_tests_properties(TestParaViewSDKInstall PROPERTIES
                       LABELS "PARAVIEW"
                       TIMEOUT 1500)
endif ()
