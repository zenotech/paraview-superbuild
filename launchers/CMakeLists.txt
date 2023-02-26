cmake_minimum_required(VERSION 3.12)
project(launchers)

find_package(ParaView REQUIRED)

option(LAUNCHER_ENABLE_MESA "Enable Mesa launch option" OFF)
option(LAUNCHER_ENABLE_OSMESA "Enable OSMesa launch option" OFF)
option(LAUNCHER_ENABLE_MPI  "Enable MPI launch option" OFF)

set(LAUNCHER_MESA_LIBDIR "<LIBDIR>/mesa"
  CACHE STRING "The directory containing the Mesa libraries (<LIBDIR> is replaced with the runtime library install location)")

set(LAUNCHER_MPI_LIBDIR "<LIBDIR>/mpi"
  CACHE STRING "The directory containing the MPI libraries (<LIBDIR> is replaced with the runtime library install location)")


include(GNUInstallDirs)
if (WIN32)
  set(_launcher_replacement "${CMAKE_INSTALL_BINDIR}")
else ()
  set(_launcher_replacement "${CMAKE_INSTALL_LIBDIR}")
endif ()

string(REPLACE "<LIBDIR>" "${_launcher_replacement}" _launcher_mesa_libdir "${LAUNCHER_MESA_LIBDIR}")
file(RELATIVE_PATH _launcher_mesa_relpath
  "/prefix/${CMAKE_INSTALL_BINDIR}"
  "/prefix/${_launcher_mesa_libdir}")

string(REPLACE "<LIBDIR>" "${_launcher_replacement}" _launcher_mpi_libdir "${LAUNCHER_MPI_LIBDIR}")
file(RELATIVE_PATH _launcher_mpi_relpath
  "/prefix/${CMAKE_INSTALL_BINDIR}"
  "/prefix/${_launcher_mpi_libdir}")

# Set up rpaths
set(CMAKE_BUILD_RPATH_USE_ORIGIN 1)
if (UNIX AND NOT APPLE)
  file(RELATIVE_PATH _launcher_client_relpath
    "/prefix/${CMAKE_INSTALL_BINDIR}"
    "/prefix/${CMAKE_INSTALL_LIBDIR}")
  set(_launcher_client_origin_rpath
    "$ORIGIN/${_launcher_client_relpath}")
  list(APPEND CMAKE_INSTALL_RPATH
    "${_launcher_client_origin_rpath}")
endif()


set(tools
  paraview
  pvbatch
  pvdataserver
  pvpython
  pvrenderserver
  pvserver)

foreach(tool IN LISTS tools)
  if (NOT TARGET ParaView::${tool})
    continue()
  endif()

  set(name "${tool}-launcher")
  add_executable(${name}
    launcher.cxx)
  add_executable(Launcher::${tool} ALIAS ${name})
  target_link_libraries(${name}
    PRIVATE
      VTK::vtksys)
  target_compile_definitions(${name}
    PRIVATE
      "MESA_RELATIVE_LIBDIR=\"${_launcher_mesa_relpath}\""
      "MPI_RELATIVE_LIBDIR=\"${_launcher_mpi_relpath}\""
      "TOOL=\"${tool}\""
      "TOOL_SUFFIX=\"-real\"")
  target_compile_definitions(${name}
    PRIVATE
      "ENABLE_MPI=$<BOOL:${LAUNCHER_ENABLE_MPI}>"
      "ENABLE_MESA=$<BOOL:${LAUNCHER_ENABLE_MESA}>"
      "ENABLE_OSMESA=$<BOOL:${LAUNCHER_ENABLE_OSMESA}>"
  install(
    TARGETS     "${name}"
    DESTINATION "${CMAKE_INSTALL_BINDIR}"
    COMPONENT   runtime)
endforeach()
