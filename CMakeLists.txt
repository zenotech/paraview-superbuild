cmake_minimum_required(VERSION 3.5)

project(ParaViewSuperBuild)

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
    png
    python
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
        diy
        genericio
        qhull)
    endif ()
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

process_dependencies()

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
