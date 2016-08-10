cmake_minimum_required(VERSION 3.5)

project(paraview-superbuild)

list(INSERT CMAKE_MODULE_PATH 0
  "${CMAKE_CURRENT_LIST_DIR}/cmake")

macro (superbuild_setup_variables)
  include(SuperbuildVersionMacros)
  superbuild_set_version_variables(paraview "5.1.2" "paraview-version.cmake")
  set(paraview_version "${paraview_version_major}.${paraview_version_minor}")
endmacro ()

function (superbuild_find_projects var)
  include(ParaViewSuperbuildMacros)

  set(projects
    cxx11
    paraview
    python)

  option(USE_NONFREE_COMPONENTS "Enable the non-free parts of the superbuild" OFF)
  mark_as_advanced(USE_NONFREE_COMPONENTS)

  list(APPEND projects
    boost
    bzip2
    cgns
    freetype
    hdf5
    ispc
    netcdf
    matplotlib
    mpi
    numpy
    ospray
    #paraviewsdk
    paraviewweb
    paraviewwebvisualizer
    png
    python
    pythonsetuptools
    qt4
    qt5
    silo
    szip
    tbb
    visitbridge
    vortexfinder2
    vrpn
    xdmf3
    zlib)

  if (NOT APPLE)
    list(APPEND projects
      manta)
  endif ()

  if (UNIX)
    list(APPEND projects
      adios
      ffmpeg
      libxml2
      mxml)

    if (NOT APPLE)
      list(APPEND projects
        catalyst
        egl
        fontconfig
        llvm
        mesa
        osmesa
        portfwd)
    endif ()
  endif ()

  list(APPEND projects
    paraviewgettingstartedguide
    paraviewtutorial
    paraviewtutorialdata
    paraviewusersguide)

  if (USE_NONFREE_COMPONENTS)
    list(APPEND projects
      acusolve
      vistrails)

    if (UNIX)
      list(APPEND projects
        cosmotools
        genericio)
    endif ()
  endif ()

  if (WIN32)
    list(APPEND projects
      pywin32)
  endif ()

  set("${var}"
    ${projects}
    PARENT_SCOPE)
endfunction ()

function (superbuild_sanity_check)
  if (NOT paraview_enabled AND NOT catalyst_enabled)
    message(WARNING "ParaView is disabled...")
  endif ()

  include(qt.functions)

  superbuild_qt_sanity_check()

  # Sanity check: Cannot have EGL and Qt enabled at the same time.
  if (egl_enabled AND (qt4_enabled OR qt5_enabled))
    message(SEND_ERROR "Cannot enable EGL and Qt at the same time.")
  endif ()

  # Sanity check: Cannot have EGL and Mesa at the same time.
  if (egl_enabled AND mesa_enabled)
    message(SEND_ERROR "Cannot enable EGL and Mesa at the same time.")
  endif ()

  # Sanity check: Must use OpenGL2 backed with EGL
  if (egl_enabled AND NOT PARAVIEW_RENDERING_BACKEND STREQUAL "OpenGL2")
    message(SEND_ERROR "Cannot enable EGL with the old VTK rendering backend at the same time.")
  endif ()

  # Sanity check: Cannot have EGL and OSMesa at the same time.
  if (egl_enabled AND osmesa_enabled)
    message(SEND_ERROR "Cannot enable EGL and OSMesa at the same time.")
  endif ()

  # Sanity check: Cannot have OSMesa and Qt enabled at the same time.
  if (osmesa_enabled AND (qt4_enabled OR qt5_enabled))
    message(SEND_ERROR "Cannot enable OSMesa and Qt at the same time.")
  endif ()

  # Sanity check: Cannot have OSMesa and Mesa at the same time.
  if (osmesa_enabled AND mesa_enabled)
    message(SEND_ERROR "Cannot enable OSMesa and Mesa at the same time.")
  endif ()

  # Sanity check: Cannot have ParaView and Catalyst enabled at the same time.
  if (paraview_enabled AND catalyst_enabled)
    message(SEND_ERROR "Cannot enable ParaView and Catalyst at the same time.")
  endif ()
endfunction ()

function (superbuild_add_packaging)
  if (WIN32)
    set(generators
      NSIS
      ZIP)
  elseif (APPLE)
    set(generators
      DragNDrop)
  else ()
    set(generators
      TGZ)
  endif ()

  if (USE_SYSTEM_qt4)
    list(APPEND superbuild_export_variables
      QT_LIBRARY_DIR)
  endif ()

  include(paraview.suffix)
  list(APPEND superbuild_export_variables
    PARAVIEW_PACKAGE_SUFFIX)

  foreach (generator IN LISTS generators)
    if (paraview_enabled)
      superbuild_add_extra_package_test(paraview "${generator}"
        LABELS  "ParaView"
        TIMEOUT 1200)
    endif ()
    if (catalyst_enabled)
      superbuild_add_extra_package_test(catalyst "${generator}"
        LABELS  "ParaView"
        TIMEOUT 1200)
    endif ()
  endforeach ()
endfunction ()

function (superbuild_add_tests)
  add_subdirectory("${CMAKE_SOURCE_DIR}/tests" "${CMAKE_BINARY_DIR}/tests")
endfunction ()

set(boost_libraries
  date_time
  system
  thread)

list(APPEND superbuild_version_files
  "${CMAKE_CURRENT_LIST_DIR}/versions.cmake")
list(APPEND extra_ctest_custom_files
  "${CMAKE_CURRENT_LIST_DIR}/cmake/CTestCustom.cmake")
list(APPEND superbuild_project_roots
  "${CMAKE_CURRENT_LIST_DIR}/projects")

if (NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/superbuild/CMakeLists.txt")
  message(FATAL_ERROR "It appears as though the superbuild infrastructure "
                      "is missing; did you forget to do `git submodule init` "
                      "and `git submodule update`?")
endif ()

add_subdirectory(superbuild)
