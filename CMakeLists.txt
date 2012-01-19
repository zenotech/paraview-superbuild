cmake_minimum_required(VERSION 2.8)
project(ParaViewSuperBuild)
set (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/CMake")

include (ParaViewModules)

set (internal_install_root "${CMAKE_CURRENT_BINARY_DIR}/install")
set (ldflags "$ENV{LDFLAGS} -L${internal_install_root}/lib")
set (cppflags "$ENV{CPPFLAGS} -I${internal_install_root}/include")

add_project(zlib)
add_project(png)
add_project(python)
add_project(freetype)
add_project(szip)
add_project(hdf5)
add_project(silo)
add_project(cgns)
