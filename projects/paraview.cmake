set(PARAVIEW_EXTRA_CMAKE_ARGUMENTS ""
    CACHE STRING "Extra arguments to be passed to ParaView when configuring.")
mark_as_advanced(PARAVIEW_EXTRA_CMAKE_ARGUMENTS)

set (paraview_extra_cmake_options)
if (PV_NIGHTLY_SUFFIX)
  list(APPEND paraview_extra_cmake_options
    -DPV_NIGHTLY_SUFFIX:STRING=${PV_NIGHTLY_SUFFIX})
endif ()

set(paraview_install_development_files FALSE)
if ((UNIX AND NOT APPLE) OR paraviewsdk_enabled)
  set(paraview_install_development_files TRUE)
endif ()

# Without an offscreen rendering backend, X should be used.
set(paraview_use_x ON)
if (WIN32 OR APPLE OR osmesa_enabled OR egl_enabled)
  set(paraview_use_x OFF)
endif()

set(paraview_visit_gmv ON)
if (osmesa_enabled OR egl_enabled)
  set(paraview_visit_gmv OFF)
endif ()

set(paraview_use_qt OFF)
if (qt4_enabled OR qt5_enabled)
  set(paraview_use_qt ON)
endif ()

set(PARAVIEW_RENDERING_BACKEND "OpenGL2"
  CACHE STRING "Rendering backend to use for ParaView")
set_property(CACHE PARAVIEW_RENDERING_BACKEND
  PROPERTY
    STRINGS "OpenGL;OpenGL2")

option(PARAVIEW_BUILD_WEB_DOCUMENTATION "Build documentation for the web" OFF)

set(paraview_all_plugins
  vortexfinder2)

if (superbuild_build_phase)
  get_property(paraview_plugins GLOBAL
    PROPERTY paraview_plugins)

  set(paraview_plugin_dirs)
  foreach (paraview_plugin IN LISTS paraview_plugins)
    if (${paraview_plugin}_enabled AND TARGET "${paraview_plugin}")
      set(plugin_source_dir "<SOURCE_DIR>")
      _ep_replace_location_tags("${paraview_plugin}" plugin_source_dir)
      list(APPEND paraview_plugin_dirs
        "${plugin_source_dir}")
    endif ()
  endforeach ()
  string(REPLACE ";" "${_superbuild_list_separator}" paraview_plugin_dirs "${paraview_plugin_dirs}")
endif ()

if (NOT CMAKE_CONFIGURATION_TYPES AND NOT WIN32)
  set(PARAVIEW_BUILD_TYPE ""
    CACHE STRING "ParaView's build mode")
  mark_as_advanced(PARAVIEW_BUILD_TYPE)
  if (NOT PARAVIEW_BUILD_TYPE)
    set(PARAVIEW_BUILD_TYPE "${CMAKE_BUILD_TYPE}")
  endif ()

  set(CMAKE_BUILD_TYPE_save "${CMAKE_BUILD_TYPE}")
  set(CMAKE_BUILD_TYPE "${PARAVIEW_BUILD_TYPE}")
endif ()

set(paraview_smp_backend "Sequential")
if (tbb_enabled)
  set(paraview_smp_backend "TBB")
endif ()

set(PARAVIEW_EXTERNAL_PROJECTS ""
  CACHE STRING "A list of projects for ParaView to depend on")
mark_as_advanced(PARAVIEW_EXTERNAL_PROJECTS)

option(PARAVIEW_FREEZE_PYTHON "Freeze Python packages and modules into the application" OFF)

set(paraviews_platform_dependencies)
if (UNIX)
  if (NOT APPLE)
    list(APPEND paraviews_platform_dependencies
      mesa osmesa egl

      # Needed for fonts to work properly.
      fontconfig)
  endif ()
  list(APPEND paraviews_platform_dependencies
    adios ffmpeg libxml2 freetype

    # For cosmotools
    genericio cosmotools)
endif ()

superbuild_add_project(paraview
  DEBUGGABLE
  DEFAULT_ON
  DEPENDS_OPTIONAL
    cxx11 boost hdf5 matplotlib mpi numpy png
    python qt4 qt5 visitbridge zlib silo cgns
    xdmf3 ospray vrpn tbb netcdf
    paraviewusersguide paraviewgettingstartedguide
    paraviewtutorial paraviewtutorialdata paraviewweb
    ${paraview_all_plugins}
    ${paraviews_platform_dependencies}
    ${PARAVIEW_EXTERNAL_PROJECTS}

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_TESTING:BOOL=OFF
    -DPARAVIEW_BUILD_PLUGIN_CoProcessingScriptGenerator:BOOL=ON
    -DPARAVIEW_BUILD_PLUGIN_EyeDomeLighting:BOOL=ON
    -DPARAVIEW_BUILD_QT_GUI:BOOL=${paraview_use_qt}
    -DPARAVIEW_ENABLE_FFMPEG:BOOL=${ffmpeg_enabled}
    -DPARAVIEW_ENABLE_PYTHON:BOOL=${python_enabled}
    -DPARAVIEW_ENABLE_COSMOTOOLS:BOOL=${cosmotools_enabled}
    -DPARAVIEW_ENABLE_XDMF3:BOOL=${xdmf3_enabled}
    -DPARAVIEW_USE_MPI:BOOL=${mpi_enabled}
    -DPARAVIEW_USE_OSPRAY:BOOL=${ospray_enabled}
    -DPARAVIEW_USE_VISITBRIDGE:BOOL=${visitbridge_enabled}
    -DPARAVIEW_ENABLE_CGNS:BOOL=${cgns_enabled}
    -DVISIT_BUILD_READER_CGNS:BOOL=OFF # force to off
    -DVISIT_BUILD_READER_GMV:BOOL=${paraview_visit_gmv}
    -DVISIT_BUILD_READER_Silo:BOOL=${silo_enabled}
    -DPARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=${paraview_install_development_files}
    -DPARAVIEW_ENABLE_MATPLOTLIB:BOOL=${matplotlib_enabled}
    -DPARAVIEW_FREEZE_PYTHON:BOOL=${PARAVIEW_FREEZE_PYTHON}
    -DVTK_USE_SYSTEM_NETCDF:BOOL=${netcdf_enabled}
    -DVTK_USE_SYSTEM_FREETYPE:BOOL=${freetype_enabled}
    -DVTK_USE_SYSTEM_HDF5:BOOL=${hdf5_enabled}
    -DVTK_USE_SYSTEM_LIBXML2:BOOL=${libxml2_enabled}
    -DVTK_USE_SYSTEM_PNG:BOOL=${png_enabled}
    -DVTK_USE_SYSTEM_ZLIB:BOOL=${zlib_enabled}
    -DModule_vtkIOADIOS:BOOL=${adios_enabled}
    -DVTK_RENDERING_BACKEND:STRING=${PARAVIEW_RENDERING_BACKEND}
    -DVTK_SMP_IMPLEMENTATION_TYPE:STRING=${paraview_smp_backend}
    -DVTK_LEGACY_SILENT:BOOL=ON
    -DVTK_USE_OSMESA:BOOL=${osmesa_enabled}
    -DVTK_USE_OFFSCREEN:BOOL=${osmesa_enabled}
    -DVTK_USE_OFFSCREEN_EGL:BOOL=${egl_enabled}
    -DVTK_USE_X:BOOL=${paraview_use_x}
    -DVTK_USE_CXX11_FEATURES:BOOL=${cxx11_enabled}

    # vrpn
    -DPARAVIEW_BUILD_PLUGIN_VRPlugin:BOOL=${vrpn_enabled}
    -DPARAVIEW_USE_VRPN:BOOL=${vrpn_enabled}

    # Web
    -DPARAVIEW_ENABLE_WEB:BOOL=${paraviewweb_enabled}
    -DPARAVIEW_BUILD_WEB_DOCUMENTATION:BOOL=${PARAVIEW_BUILD_WEB_DOCUMENTATION}

    # specify the apple app install prefix. No harm in specifying it for all
    # platforms.
    -DMACOSX_APP_INSTALL_PREFIX:PATH=<INSTALL_DIR>/Applications

    # add additional plugin directories
    -DPARAVIEW_EXTERNAL_PLUGIN_DIRS:STRING=${paraview_plugin_dirs}

    ${paraview_extra_cmake_options}

    ${PARAVIEW_EXTRA_CMAKE_ARGUMENTS})

if (NOT paraview_FROM_GIT AND adios_enabled)
  superbuild_apply_patch(paraview adios-wrapping
    "Fix broken python wrapping for ADIOS")
endif ()

if (DEFINED CMAKE_BUILD_TYPE_save)
  set(CMAKE_BUILD_TYPE "${CMAKE_BUILD_TYPE_save}")
endif ()

if (paraview_install_development_files)
  find_program(SED_EXECUTABLE sed)
  mark_as_advanced(SED_EXECUTABLE)
  if (SED_EXECUTABLE)
    superbuild_project_add_step("fixupcmakepaths"
      COMMAND "${CMAKE_COMMAND}"
              -Dinstall_location:PATH=<INSTALL_DIR>
              -Dparaview_version:STRING=${paraview_version}
              -P "${CMAKE_CURRENT_LIST_DIR}/scripts/paraview.fixupcmakepaths.cmake"
      DEPENDEES install
      WORKING_DIRECTORY <INSTALL_DIR>)
  endif ()
endif ()
