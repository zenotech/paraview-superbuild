cmake_minimum_required(VERSION 2.8.8)

if (APPLE)
  if(NOT CMAKE_OSX_DEPLOYMENT_TARGET)
    message(WARNING "Ensure that CMAKE_OSX_SYSROOT, CMAKE_OSX_DEPLOYMENT_TARGET are set correctly")
    set(CMAKE_OSX_ARCHITECTURES "x86_64" CACHE STRING "By default, build for 64-bit Leopard")
  endif()
endif()

project(ParaViewSuperBuild)
set (SuperBuild_CMAKE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/CMake")
set (SuperBuild_PROJECTS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/Projects")
set (SuperBuild_BINARY_DIR ${ParaViewSuperBuild_BINARY_DIR})

set (platform)
if (APPLE)
  set (platform "apple")
elseif (UNIX)
  set (platform "unix")
elseif (WIN32)
  set (platform "win32")
endif()

#-----------------------------------------------------------------------------
# Cross compilation
set (CROSS_BUILD_STAGE "HOST" CACHE STRING
  "Cross compilation stage: either HOST(ie no crosscompile)|TOOLS|CROSS")
set_property(CACHE CROSS_BUILD_STAGE PROPERTY STRINGS
   "HOST" "TOOLS" "CROSS")

#-----------------------------------------------------------------------------
# Setup CMAKE_MODULE_PATH so that platform specific configurations are processed
# before the generic ones.
string(TOLOWER "${CROSS_BUILD_STAGE}" lstage)
set (CMAKE_MODULE_PATH
  "${SuperBuild_PROJECTS_DIR}/${platform}/${lstage}"
  "${SuperBuild_PROJECTS_DIR}/${platform}"
  "${SuperBuild_PROJECTS_DIR}/common"
  "${SuperBuild_PROJECTS_DIR}"
  "${SuperBuild_CMAKE_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}"
  ${CMAKE_MODULE_PATH})

#-----------------------------------------------------------------------------
if (NOT CROSS_BUILD_STAGE STREQUAL "HOST")
  include(CrossCompilationMacros)

  #ask user to say what machine they are compiling onto
  #so we can get the right environment settings
  query_target_machine()

  if (CROSS_BUILD_STAGE STREQUAL "CROSS")
    #configure the platform dependent settings
    #64bit_build, static_only, mpi search path
    do_cross_platform_settings()

    #find location of hosttools or host build to get compilation tools from
    find_hosttools()
  endif()
endif()

include(CMakeDependentOption)

#-----------------------------------------------------------------------------
# Collect information about the build platform.
include(CheckTypeSize)

if (NOT CROSS_BUILD_STAGE STREQUAL "CROSS")
  check_type_size(void* VOID_PTR_SIZE BUILTIN_TYPES_ONLY)
  if (VOID_PTR_SIZE EQUAL 8)
    set (64bit_build TRUE)
  else ()
    set (64bit_build FALSE)
  endif()
endif()

# Set suffix to be used for generating archives. This ensures that the package
# files have decent names that we can directly upload to the website.
set (package_suffix "${CMAKE_SYSTEM_NAME}")
if (64bit_build)
  set (package_suffix "${package_suffix}-64bit")
else ()
  set (package_suffix "${package_suffix}-32bit")
endif()


option(TRUST_SVN_CERTIFICATES_AUTOMATICALLY
  "Trust SVN certificates automatically" ON)
mark_as_advanced(TRUST_SVN_CERTIFICATES_AUTOMATICALLY)

#-----------------------------------------------------------------------------
# Setup some standard variables that control various locations and flags.
set (install_location "${CMAKE_CURRENT_BINARY_DIR}/install")
set (download_location "${CMAKE_CURRENT_BINARY_DIR}/downloads"
     CACHE PATH "Location where source tar-balls are (to be) downloaded.")
mark_as_advanced(download_location)

if (WIN32)
  set (ldflags)
  set (cppflags)
  set (cxxflags)
  set (ld_library_path)
else ()
  # FIXME: currently, if any of these are empty, we have build issues on Unix.
  set (ldflags "$ENV{LDFLAGS} -L${install_location}/lib")
  if (NOT CROSS_BUILD_STAGE STREQUAL "CROSS")
    set (cppflags "$ENV{CPPFLAGS} -fPIC")
    set (cxxflags "$ENV{CXXFLAGS} -fPIC")
    set (cflags "$ENV{CFLAGS} -fPIC")
  endif()
  set (ld_library_path "${install_location}/lib:$ENV{LD_LIBRARY_PATH}")
endif()

if (UNIX AND NOT APPLE)
  # I am not exactly sure about the cause of these issues and how to cleanly
  # overcome them, however, on some linuxes when Cmake is built shared, we end
  # if we set LD_LIBRARY_PATH to the install/lib dir, we end up with errors
  # due to conflicts with system libz. So for now, I am making this an option.
  # By default we will let the superbuild scripts set LD_LIBRARY_PATH. However
  # if users get errors like: libz.so.1: no version information available, then
  # users should turn this flag off.
  option(PASS_LD_LIBRARY_PATH_FOR_BUILDS
         "Pass LD_LIBRARY_PATH to build scripts."
         ON)
  mark_as_advanced(PASS_LD_LIBRARY_PATH_FOR_BUILDS)
endif()

if (APPLE)
  set (cflags "${cflags} -arch x86_64 -mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET} -sysroot=${CMAKE_OSX_SYSROOT} ")
  set (cppflags "${cppflags} -arch x86_64 -mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET} -sysroot=${CMAKE_OSX_SYSROOT} ")
  set (cxxflags "${cxxflags} -arch x86_64 -mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET} -sysroot=${CMAKE_OSX_SYSROOT} ")
endif()
set (prefix_path "${install_location}")

# merge in default/user-specified CMake flags.
set (ldflags "${CMAKE_SHARED_LINKER_FLAGS} ${ldflags}")
set (cppflags "${CMAKE_CXX_FLAGS} ${cppflags}")
set (cxxflags "${CMAKE_CXX_FLAGS} ${cxxflags}")
set (cflags "${CMAKE_C_FLAGS} ${cflags}")

string (STRIP "${ldflags}" ldflags)
string (STRIP "${cppflags}" cppflags)
string (STRIP "${cxxflags}" cxxflags)
string (STRIP "${cflags}"  cflags)
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
    find_program(NMAKE_PATH nmake)
    mark_as_advanced(DEVENV_PATH NMAKE_PATH)
  endif()
  # Freetype uses its own build system on win32...
  find_program(FTJAM_EXECUTABLE jam)
  mark_as_advanced(FTJAM_EXECUTABLE)
  if (freetype_ENABLED)
    if (NOT FTJAM_EXECUTABLE)
      message(FATAL_ERROR "FreeType's 'jam' build tool not found! Download it from http://sourceforge.net/projects/freetype/files/ftjam/2.5.2/ and set FTJAM_EXECUTABLE appropriately.")
    endif()
  endif()
endif()
#-----------------------------------------------------------------------------
include (ParaViewModules)
include (versions)

#------------------------------------------------------------------------------
# enable testing support.
include(CTest)
configure_file(
  "${SuperBuild_CMAKE_DIR}/CTestCustom.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/CTestCustom.cmake" @ONLY)
#------------------------------------------------------------------------------

#-----------------------------------------------------------------------------
set (CM_PROJECTS_ALL)

# Include all optional projects. These are the ones user can pick and choose.
# Some of these allow using system libraries too.
if (CROSS_BUILD_STAGE STREQUAL "CROSS")
  #include(crossnumpy)
  include(python)
  include(mesa)
  include(paraview)
elseif(CROSS_BUILD_STAGE STREQUAL "TOOLS")
  include(boost)
  include(png)
  include(zlib)
  include(python)
  include(paraview)
  include(portfwd)
else()
  include(boost)
  include(cgns)
  include(freetype)
  include(hdf5)
  include(libxml2)
  include(manta)
  include(matplotlib)
  include(mpi)
  include(numpy)
  include(png)
  include(python)
  include(qt)
  include(silo)
  include(szip)
  include(visitbridge)
  include(zlib)

  if (UNIX)
    # Supported on Linux/Mac
    include(ffmpeg)
  endif()
  
  if (UNIX AND NOT APPLE)
    include(portfwd)
    include(fontconfig)
    include(mesa)
    include(osmesa)
  endif()

  # Build CosmologyTools on Linux and OS X
  if (UNIX)
    include(qhull)
    include(diy)
    include(cosmologytools)
  endif()

  # REMEMBER to tell VTK/ParaView to use VTK_SYSTEM_* for the
  # libraries we've built here.
  include(paraview)
  include(vistrails)
  include(acusolve)
endif()

process_dependencies()

#-------------------------------------------------------------------------
# Some sanity checks.
# Sanity check: Cannot has osmesa and qt enabled at the same time.
if (osmesa_ENABLED AND qt_ENABLED)
  message(SEND_ERROR "Cannot enable OSMesa and QT at the same time.")
endif()
# Sanity check: Cannot has osmesa and mesa at the same time.
if (osmesa_ENABLED AND mesa_ENABLED)
  message(SEND_ERROR "Cannot enable OSMesa and Mesa at the same time.")
endif()
#-------------------------------------------------------------------------

if (paraview_ENABLED)
  include(paraview.bundle OPTIONAL)
endif()

option(NIGHTLY_BINARY_TESTING "Run Nightly-Binary ParaView Testing" OFF)
if (NIGHTLY_BINARY_TESTING)
  add_subdirectory(tests)
endif()
