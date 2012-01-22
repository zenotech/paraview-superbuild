cmake_minimum_required(VERSION 2.8)
project(ParaViewSuperBuild)
set (platform)
if (UNIX)
  set (platform "unix")
elseif (APPLE)
  set (platform "apple")
elseif (WIN32)
  set (platform "win32")
endif()

# Setup CMAKE_MODULE_PATH so that platform specific configurations are processed
# before the generic ones.
set (CMAKE_MODULE_PATH
  "${CMAKE_CURRENT_SOURCE_DIR}/CMake/${platform}"
  "${CMAKE_CURRENT_SOURCE_DIR}/CMake/common"
  "${CMAKE_CURRENT_SOURCE_DIR}/CMake"
  ${CMAKE_MODULE_PATH}
  )

set (ParaViewSuperBuild_CMAKE_DIR
  "${CMAKE_CURRENT_SOURCE_DIR}/CMake")

include (ParaViewModules)

set (install_location "${CMAKE_CURRENT_BINARY_DIR}/install")
set (download_location "${CMAKE_CURRENT_BINARY_DIR}/downloads")

set (ldflags "$ENV{LDFLAGS} -L${install_location}/lib")
set (cppflags "$ENV{CPPFLAGS} -I${install_location}/include")
set (cxxflags "$ENV{CXXFLAGS} -I${install_location}/include")
set (cflags "$ENV{CFLAGS} -I${install_location}/include")
set (ld_library_path "${install_location}/lib:$ENV{LD_LIBRARY_PATH}")
set (prefix_path "${install_location}")

string (STRIP "${ldflags}" ldflags)
string (STRIP "${cppflags}" cppflags)
string (STRIP "${cxxflags}" cxxflags)
string (STRIP "${cflags}"  cflags)


# Top-level options. These must be limited to a commonly used subset with
# default values being used for building ParaView binaries.
option(PV_COMMAND_LINE_TOOLS_ONLY
  "Turn this ON to build command lines tools alone." OFF)
# If one wants to build command line tools w/o python or Qt, they should simply
# turn off the sub-project's ENABLE_* flags.

dependent_option(PV_WITHOUT_QT_SUPPORT
  "Turn ON to build command-line tools without Qt." OFF
  "PV_COMMAND_LINE_TOOLS_ONLY" OFF)

add_project(zlib)
add_project(png)
add_project(freetype)
add_project(szip)
add_project(hdf5)
add_project(silo DEPENDS hdf5)
add_project(cgns DEPENDS hdf5)
add_project(ffmpeg)
add_project(libxml2)
add_project(fontconfig DEPENDS libxml2)
if (NOT PV_WITHOUT_QT_SUPPORT)
  add_project(qt)
endif()
add_project(python)
add_project(numpy DEPENDS python)
add_project(boost)
add_project(manta DEFAULT_OFF)
add_project(mpich2)
add_project(mesa DEFAULT_OFF)

SET (CMAKE_INSTALL_COMPONENT runtime)
## When building with Mesa and generating command line tools alone, 
## we provide the user with an option to use OSMesa.
#dependent_option(ENABLE_OSMESA
#  "Turn ON to enable Offscreen Mesa 3D support." OFF
#  "ENABLE_MESA;PV_COMMAND_LINE_TOOLS_ONLY" OFF)

# REMEMBER to tell VTK/ParaView to use VTK_SYSTEM_* for the
# libraries we've built here.
#add_project(paraview REQUIRED)
#add_project(paraview.bundle REQUIRED DEPENDS paraview)
add_project(paraview.bundle REQUIRED)
