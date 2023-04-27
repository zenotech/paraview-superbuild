cmake_minimum_required(VERSION 3.12)

project(paraview-superbuild)

list(INSERT CMAKE_MODULE_PATH 0
  "${CMAKE_CURRENT_LIST_DIR}/cmake")

macro (superbuild_setup_variables)
  include(SuperbuildVersionMacros)
  if (paraview_SOURCE_SELECTION STREQUAL "git")
    # Assuming master; just use the latest version, but let the user set their
    # own version in case it is actually a branch from some other version.
    set(PARAVIEW_VERSION_DEFAULT "5.11.1"
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
    cxx14
    paraview
    python3)

  option(USE_NONFREE_COMPONENTS "Enable the non-free parts of the superbuild" OFF)
  mark_as_advanced(USE_NONFREE_COMPONENTS)

  list(APPEND projects
    adios2
    blosc
    boost
    bzip2
    catalyst
    cuda
    curl
    eigen
    embree
    exodus
    freetype
    gdal
    geotiff
    hdf5
    h5py
    ispc
    jsonc
    jsoncpp
    las
    libjpegturbo
    lookingglass
    matplotlib
    mpi
    netcdf
    nlohmannjson
    numpy
    nvidiaindex
    occt
    openmp
    openpmd
    openimagedenoise
    openvdb
    openvkl
    ospray
    ospraymodulempi
    openxrsdk
    paraviewtranslations
    paraviewweb
    paraviewwebglance
    paraviewweblite
    paraviewwebdivvy
    paraviewwebvisualizer
    pdal
    png
    proj
    protobuf
    pybind11
    pythonaiohttp
    pythonasynctimeout
    pythonattrs
    pythonbeniget
    pythoncffi
    pythonchardet
    pythoncppy
    pythoncycler
    pythoncython
    pythondateutil
    pythongast
    pythonidna
    pythonkiwisolver
    pythonmako
    pythonmpi4py
    pythonmpmath
    pythonmultidict
    #pythonpillow
    pythonpandas
    pythonpkgconfig
    pythonply
    pythonpycparser
    pythonpygments
    pythonpyparsing
    pythonpythran
    pythonsemanticversion
    pythonsetuptools
    pythonsetuptoolsrust
    pythonsetuptoolsscm
    pythonsix
    pythontoml
    pythontypingextensions
    pythonwheel
    pythonwslinkasync
    pythonyarl
    pytz
    #qhull
    qt5
    rkcommon
    scipy
    seacas
    silo
    snappy
    sqlite
    sympy
    szip
    tiff
    ttk
    tbb
    visitbridge
    vortexfinder2
    vrpn
    vtkm
    xdmf3
    xerces
    xz
    zfp
    zlib
    zstd)

  if (ALLOW_openssl)
    list(APPEND projects openssl)
  endif ()

  if (UNIX)
    list(APPEND projects
      cdi
      cosmotools
      ffi
      ffmpeg
      fides
      fortran
      genericio
      gmsh
      lapack
      libxml2
      mili
      pkgconf
      rapidjson
      surfacetrackercut)

    if (NOT APPLE)
      list(APPEND projects
        egl
        expat
        fontconfig
        glproto
        gperf
        launchers
        libfabric
        llvm
        meson
        mesa
        ninja
        osmesa
        paraviewsdk
        socat
        utillinux)
    endif ()
  endif ()

  list(APPEND projects
    ospraymaterials
    paraviewgettingstartedguide
    paraviewtutorialdata)

  if (USE_NONFREE_COMPONENTS)
    # add non-free projects here.
    if (WIN32 OR (UNIX AND NOT APPLE))
      # These are publicly available, but are behind logins or license
      # acceptances. Rehosted internally at Kitware for build machines.
      list(APPEND projects
        nvidiamdl
        nvidiaoptix)

      # These are open source, but require closed SDKs.
      list(APPEND projects
        visrtx)
    endif ()
    if (WIN32 OR APPLE)
      # requires a login to download the SDK, so hosted internally at Kitware.
      list(APPEND projects
        threedxwaresdk
        )
    endif()
  endif ()

  if (WIN32)
    list(APPEND projects
      openvr
      pywin32
      zeromq)
  endif ()

  set("${var}"
    ${projects}
    PARENT_SCOPE)
endfunction ()

# Add option to control OpenSSL
option(ALLOW_openssl "Make OpenSSL available (default OFF)" OFF)
mark_as_advanced(ALLOW_openssl)
if (ALLOW_openssl)
  set(_superbuild_enable_openssl ON)
endif ()

function (superbuild_sanity_check)
  if (NOT paraview_enabled AND NOT catalyst_enabled)
    message(WARNING "ParaView is disabled...")
  endif ()

  # Sanity check: Cannot have paraview and have cxx11 disabled.
  if (NOT cxx11_enabled AND paraview_enabled)
    #While ParaView doesn't depend on cxx11 it needs to make sure that
    #other projects that optionally depend on it are built with cxx11
    message(SEND_ERROR "Cannot disable cxx11 when paraview is enabled.")
  endif ()

  # Sanity check: Cannot have EGL and Qt enabled at the same time.
  if (egl_enabled AND qt5_enabled)
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

  # Sanity check: Cannot have OSMesa and Qt enabled at the same time if we're building ParaView.
  if (osmesa_enabled AND qt5_enabled AND paraview_enabled)
    message(SEND_ERROR "Cannot enable OSMesa and Qt at the same time.")
  endif ()

  # Sanity check: Cannot have OSMesa and Mesa at the same time.
  if (osmesa_enabled AND mesa_enabled)
    message(SEND_ERROR "Cannot enable OSMesa and Mesa at the same time.")
  endif ()

  # Sanity check: report cases where it doesn't make any sense to enable launchers.
  if (launchers_enabled AND NOT (mesa_enabled OR mpi_enabled))
    message(SEND_ERROR "Launchers cannot be enabled since neither MPI or MESA is enabled.")
  endif ()

  if (launchers_enabled AND mpi_enabled AND USE_SYSTEM_mpi AND NOT mesa_enabled)
    message(SEND_ERROR "Launchers cannot be enabled since MESA is not enabled and USE_SYSTEM_mpi is ON.")
  endif ()
endfunction ()

function (superbuild_add_packaging)
  if (WIN32)
    set(generators
      ZIP
      WIX)
  elseif (APPLE)
    set(generators
      DragNDrop)
  else ()
    set(generators
      TGZ)
  endif ()
  list(GET generators 0 default_generator)

  list(APPEND superbuild_export_variables
    paraview_always_package_scipy)

  if (qt5_enabled AND (USE_SYSTEM_qt5 OR APPLE OR WIN32))
    list(APPEND superbuild_export_variables
      Qt5_DIR)
    find_package(Qt5 QUIET REQUIRED COMPONENTS Core)
    set(qt5_version "${Qt5Core_VERSION_MAJOR}.${Qt5Core_VERSION_MINOR}")
  else ()
    set(qt5_version "${qt5_SOURCE_SELECTION}")
  endif ()
  list(APPEND superbuild_export_variables
    qt5_version
    qt5_ENABLE_MULTIMEDIA)

  if (NOT DEFINED PARAVIEW_CATALYST_EDITION)
    set(PARAVIEW_CATALYST_EDITION Full)
  endif ()

  if (BUILD_SHARED_LIBS_paraview STREQUAL "<same>")
    set(paraview_is_shared "${BUILD_SHARED_LIBS}")
  else ()
    set(paraview_is_shared "${BUILD_SHARED_LIBS_paraview}")
  endif ()

  include(paraview.suffix)
  list(APPEND superbuild_export_variables
    mesa_USE_SWR
    mesa_SWR_ARCH
    nvidiaindex_SOURCE_SELECTION
    PARAVIEW_PACKAGE_SUFFIX
    PARAVIEW_CATALYST_EDITION
    paraview_is_shared)

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

  if (zfp_enabled)
    # ZFP will look for OpenMP and enable it if OPENMP_FOUND is set to
    # true. Do the same here and export a variable to the packaging step
    # if it is found.
    find_package(OpenMP COMPONENTS C)
    if (OPENMP_FOUND)
      set(CMAKE_INSTALL_OPENMP_LIBRARIES 1 CACHE BOOL "Install OpenMP runtime libraries")
      list(APPEND superbuild_export_variables CMAKE_INSTALL_OPENMP_LIBRARIES)
    endif()
  endif()

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
  endforeach ()

  if (paraviewsdk_enabled)
    set(default_package paraviewsdk)
    superbuild_add_extra_package_test(paraviewsdk "TGZ"
      LABELS  "ParaView"
      TIMEOUT 6400)
    superbuild_add_extra_package_test(paraviewsdk "TXZ"
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

set(qt5_skip_modules
  qtconnectivity
  qtgamepad
  qtlocation
  qtsensors
  qtserialport
  qtwayland
  qtwebchannel
  qtwebengine
  qtwebsockets)

set(boost_libraries
  atomic
  chrono
  date_time
  filesystem
  iostreams
  program_options
  regex
  system
  thread)
set(boost_extra_options
  "-sNO_BZIP2=1")

list(APPEND superbuild_version_files
  "${CMAKE_CURRENT_LIST_DIR}/versions.cmake")
list(APPEND superbuild_ctest_custom_files
  "${CMAKE_CURRENT_LIST_DIR}/cmake/CTestCustom.cmake")
list(APPEND superbuild_project_roots
  "${CMAKE_CURRENT_LIST_DIR}/projects")

# set the default arguments used for "git clone"
set(_git_clone_arguments_default --progress)

# set the default for cxx11 to be enabled for this project
set(_superbuild_default_cxx11 ON)

# Enable nlohmann_json by default
set(_superbuild_default_nlohmannjson ON)

# set the default for qt5 to be 5.12
set(_superbuild_qt5_default_selection "5.12")

# Force qt SVG support, so ParaView can use SVG icons
set(qt5_ENABLE_SVG ON CACHE INTERNAL "ParaView requires SVG support")

# ParaView's superbuild does not support static-everywhere builds. But let
# people around the check if they want it.
if (NOT PARAVIEW_I_WANT_EVERYTHING_STATIC)
  set(_superbuild_no_static_everywhere ON)
endif ()
option(BUILD_SHARED_LIBS "Build shared or static libs" ON)
if (NOT BUILD_SHARED_LIBS AND _superbuild_no_static_everywhere)
  message(FATAL_ERROR
    "Setting BUILD_SHARED_LIBS=OFF is almost certainly what you don't want. "
    "Maybe you want the `BUILD_SHARED_LIBS_paraview=OFF` option?")
endif ()

# Build UCS4 binaries by default. This is more compatible with Linux
# distributions.
set(_python_unicode_default "UCS4")

# The projects end up with "errors" in their output that CDash ends up seeing
# and thinking things went wrong.
set(_superbuild_suppress_matplotlib_output ON)

if (NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/superbuild/CMakeLists.txt")
  message(FATAL_ERROR "It appears as though the superbuild infrastructure "
                      "is missing; did you forget to do `git submodule init` "
                      "and `git submodule update`?")
endif ()

# Warn about deprecated PARAVIEW_DEFAULT_SYSTEM_GL.
if (DEFINED PARAVIEW_DEFAULT_SYSTEM_GL)
  message(WARNING "The 'PARAVIEW_DEFAULT_SYSTEM_GL' variable is deprecated. "
    "Use the 'launchers' project instead.")
  set(_superbuild_default_launchers "${PARAVIEW_DEFAULT_SYSTEM_GL}")
endif()

add_subdirectory(superbuild)
