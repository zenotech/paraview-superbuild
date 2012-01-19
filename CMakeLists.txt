cmake_minimum_required(VERSION 2.8)
project(ParaViewSuperBuild)
set (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/CMake")

include (ParaViewModules)

set (internal_install_root "${CMAKE_CURRENT_BINARY_DIR}/install")
add_project(zlib)
add_project(png)
add_project(python)
