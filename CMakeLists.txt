cmake_minimum_required(VERSION 2.8)
project(ParaViewSuperBuild)
set (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/CMake")

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
  "Turn this on to build command lines tools alone." OFF)
# If one wants to build command line tools w/o python or Qt, they should simply
# turn off the sub-project's ENABLE_* flags.

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
add_project(qt)
add_project(python)
add_project(numpy DEPENDS python)
add_project(boost)
add_project(manta)

# REMEMBER to tell VTK/ParaView to use VTK_SYSTEM_* for the
# libraries we've built here.
add_project(paraview REQUIRED)
