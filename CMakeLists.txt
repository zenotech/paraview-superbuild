cmake_minimum_required(VERSION 3.6.1)

project(paraview-superbuild)

list(INSERT CMAKE_MODULE_PATH 0
  "${CMAKE_CURRENT_LIST_DIR}/cmake")

macro (superbuild_setup_variables)
  include(SuperbuildVersionMacros)
  if (paraview_SOURCE_SELECTION STREQUAL "git")
    # Assuming master; just use the latest version, but let the user set their
    # own version in case it is actually a branch from some other version.
    set(PARAVIEW_VERSION_DEFAULT "5.3.0"
      CACHE STRING "The default version of ParaView to use if it cannot be detected")
    mark_as_advanced(PARAVIEW_VERSION_DEFAULT)
    set(paraview_default_version "${PARAVIEW_VERSION_DEFAULT}")
  elseif (paraview_SOURCE_SELECTION STREQUAL "source")
    # If it is a git repo, we'll get it that way, otherwise we will look at the
    # `version.txt` in the checkout.
    set(paraview_default_version "")
  else ()
    # The selection is the version number; use it.
    set(paraview_default_version "${paraview_SOURCE_SELECTION}")
  endif()
  superbuild_set_version_variables(paraview "${paraview_default_version}" "paraview-version.cmake" "version.txt")
  set(paraview_version "${paraview_version_major}.${paraview_version_minor}")
endmacro ()

function (superbuild_find_projects var)
  include(ParaViewSuperbuildMacros)

  set(projects
    cxx11
    paraview
    paraviewpluginsexternal
    python)

  option(USE_NONFREE_COMPONENTS "Enable the non-free parts of the superbuild" OFF)
  mark_as_advanced(USE_NONFREE_COMPONENTS)

  list(APPEND projects
    boost
    bzip2
    embree
    freetype
    hdf5
    ispc
    lapack
    netcdf
    matplotlib
    mpi
    numpy
    ospray
    paraviewweb
    paraviewwebvisualizer
    paraviewweblightviz
    png
    python
    pythonsetuptools
    qt
    qt4
    qt5
    silo
    szip
    tbb
    visitbridge
    vortexfinder2
    vrpn
    vtkm
    xdmf3
    zlib)

  if (UNIX)
    list(APPEND projects
      adios
      cosmotools
      ffmpeg
      fortran
      genericio
      libxml2
      mxml
      scipy)

    if (NOT APPLE)
      list(APPEND projects
        boxlib
        catalyst
        egl
        fontconfig
        glproto
        llvm
        mesa
        osmesa
        paraviewsdk
        socat)
    endif ()
  endif ()

  list(APPEND projects
    paraviewgettingstartedguide
    paraviewtutorial
    paraviewtutorialdata
    paraviewusersguide)

  if (USE_NONFREE_COMPONENTS)
    list(APPEND projects
      acusolve)
  endif ()

  if (WIN32)
    list(APPEND projects
      ftjam
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
      ZIP
      NSIS)
  elseif (APPLE)
    set(generators
      DragNDrop)
  else ()
    set(generators
      TGZ)
  endif ()
  list(GET generators 0 default_generator)

  if (USE_SYSTEM_qt4)
    list(APPEND superbuild_export_variables
      QT_LIBRARY_DIR)
  endif ()

  if (USE_SYSTEM_qt5)
    list(APPEND superbuild_export_variables
      Qt5_DIR)
  endif ()

  if (NOT DEFINED PARAVIEW_CATALYST_EDITION)
    set(PARAVIEW_CATALYST_EDITION Full)
  endif ()

  include(paraview.suffix)
  list(APPEND superbuild_export_variables
    mesa_USE_SWR
    PARAVIEW_DEFAULT_SYSTEM_GL
    PARAVIEW_PACKAGE_SUFFIX
    PARAVIEW_CATALYST_EDITION)

  if (paraview_enabled)
    set(PARAVIEW_PACKAGE_FILE_NAME ""
      CACHE STRING "If set, overrides the generated filename for the package")
    list(APPEND superbuild_export_variables
      PARAVIEW_PACKAGE_FILE_NAME)
  endif ()

  if (paraviewsdk_enabled)
    set(PARAVIEWSDK_PACKAGE_FILE_NAME ""
      CACHE STRING "If set, overrides the generated filename for the package")
    list(APPEND superbuild_export_variables
      PARAVIEWSDK_PACKAGE_FILE_NAME)
  endif ()

  set(paraview_PLUGINS_AUTOLOAD ""
    CACHE STRING "List of plugins to autoload")
  foreach (paraview_plugin IN LISTS paraview_PLUGINS_AUTOLOAD)
    set("paraview_plugin_${paraview_plugin}_auto_load" 1)
    list(APPEND superbuild_export_variables
      "paraview_plugin_${paraview_plugin}_auto_load")
  endforeach ()

  set(default_package)

  foreach (generator IN LISTS generators)
    if (paraview_enabled)
      if (NOT default_package)
        set(default_package paraview)
      endif ()
      superbuild_add_extra_package_test(paraview "${generator}"
        LABELS  "ParaView"
        TIMEOUT 6400)
    endif ()
    if (catalyst_enabled OR (paraview_enabled AND UNIX AND NOT APPLE))
      if (NOT default_package)
        set(default_package catalyst)
      endif ()
      superbuild_add_extra_package_test(catalyst "${generator}"
        LABELS  "ParaView"
        TIMEOUT 6400)
    endif ()
  endforeach ()

  if (paraviewsdk_enabled)
    set(default_package paraviewsdk)
    superbuild_add_extra_package_test(paraviewsdk "TGZ"
      LABELS  "ParaView"
      TIMEOUT 6400)
  endif ()

  if (default_package)
    superbuild_enable_install_target("${default_package}/${default_generator}")
  endif ()
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
list(APPEND superbuild_ctest_custom_files
  "${CMAKE_CURRENT_LIST_DIR}/cmake/CTestCustom.cmake")
list(APPEND superbuild_project_roots
  "${CMAKE_CURRENT_LIST_DIR}/projects")

# set the default arguments used for "git clone"
set(_git_clone_arguments_default --progress)

if (NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/superbuild/CMakeLists.txt")
  message(FATAL_ERROR "It appears as though the superbuild infrastructure "
                      "is missing; did you forget to do `git submodule init` "
                      "and `git submodule update`?")
endif ()

add_subdirectory(superbuild)
