set(PARAVIEW_EXTRA_CMAKE_ARGUMENTS ""
  CACHE STRING "Extra arguments to be passed to ParaView when configuring.")
mark_as_advanced(PARAVIEW_EXTRA_CMAKE_ARGUMENTS)

option(PARAVIEW_DEFAULT_SYSTEM_GL "Default to using the system OpenGL" OFF)

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

set(paraview_all_plugins)

if (superbuild_build_phase)
  get_property(paraview_plugins GLOBAL
    PROPERTY paraview_plugins)
  get_property(paraview_plugin_dirs_external GLOBAL
    PROPERTY paraview_plugin_dirs_external)

  set(paraview_plugin_dirs
    "${paraview_plugin_dirs_external}")
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

set(paraview_enable_cuda "OFF")
if(vtkm_enabled AND cuda_enabled)
  set(paraview_enable_cuda "ON")
endif()

set(PARAVIEW_EXTERNAL_PROJECTS ""
  CACHE STRING "A list of projects for ParaView to depend on")
mark_as_advanced(PARAVIEW_EXTERNAL_PROJECTS)

option(PARAVIEW_FREEZE_PYTHON "Freeze Python packages and modules into the application" OFF)

set(paraviews_platform_dependencies)
if (UNIX)
  if (NOT APPLE)
    list(APPEND paraviews_platform_dependencies
      mesa osmesa egl

      boxlib

      # Needed for fonts to work properly.
      fontconfig)
  endif ()
  list(APPEND paraviews_platform_dependencies
    adios ffmpeg libxml2 freetype

    # For cosmotools
    genericio cosmotools)
endif ()

set(paraview_mesa_sb_available FALSE)
if (PARAVIEW_DEFAULT_SYSTEM_GL AND mesa_enabled)
  set(paraview_mesa_sb_available TRUE)
endif ()

if (WIN32)
  list(APPEND paraviews_platform_dependencies
    openvr)
endif ()

set(PARAVIEW_ENABLE_PYTHON ${python_enabled})
if (python_enabled AND USE_SYSTEM_python AND NOT python_FIND_LIBRARIES)
  set(PARAVIEW_ENABLE_PYTHON OFF)
endif()

if (expat_ENABLED)
  list(APPEND paraviews_platform_dependencies expat)
endif ()

cmake_dependent_option(PARAVIEW_INITIALIZE_MPI_ON_CLIENT
  "Initialize MPI on client-processes by default. Can be overridden using command line arguments" ON
  "mpi_enabled" OFF)
mark_as_advanced(PARAVIEW_INITIALIZE_MPI_ON_CLIENT)

if (mpi_enabled)
  list(APPEND paraview_extra_cmake_options
    -DPARAVIEW_INITIALIZE_MPI_ON_CLIENT:BOOL=${PARAVIEW_INITIALIZE_MPI_ON_CLIENT})
endif()

option(PARAVIEW_ENABLE_MOTIONFX "Enable MotionFX reader, if supported on platform" ON)
mark_as_advanced(PARAVIEW_ENABLE_MOTIONFX)

if(adios_enabled)
  set(adios_module_flag "YES")
else()
  set(adios_module_flag "NO")
endif()

superbuild_add_project(paraview
  DEBUGGABLE
  DEFAULT_ON
  DEPENDS
    hdf5
  DEPENDS_OPTIONAL
    cuda boost matplotlib mpi numpy png
    python qt5 visitbridge zlib silo las
    xdmf3 ospray vrpn vtkm tbb netcdf
    paraviewgettingstartedguide
    paraviewtutorialdata paraviewweb
    paraviewpluginsexternal
    ${paraview_all_plugins}
    ${paraviews_platform_dependencies}
    ${PARAVIEW_EXTERNAL_PROJECTS}

  CMAKE_ARGS
    -DPARAVIEW_BUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DPARAVIEW_BUILD_TESTING:BOOL=OFF
    -DCMAKE_INSTALL_LIBDIR:PATH=lib
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DPARAVIEW_PLUGIN_ENABLE_OpenVR:BOOL=${openvr_enabled}
    -DPARAVIEW_BUILD_QT_GUI:BOOL=${qt5_enabled}
    -DPARAVIEW_ENABLE_FFMPEG:BOOL=${ffmpeg_enabled}
    -DPARAVIEW_ENABLE_PYTHON:BOOL=${PARAVIEW_ENABLE_PYTHON}
    -DPARAVIEW_PYTHON_VERSION:STRING=2
    -DPARAVIEW_ENABLE_COSMOTOOLS:BOOL=${cosmotools_enabled}
    -DPARAVIEW_ENABLE_XDMF3:BOOL=${xdmf3_enabled}
    -DPARAVIEW_ENABLE_LAS:BOOL=${las_enabled}
    -DPARAVIEW_ENABLE_MOTIONFX:BOOL=${PARAVIEW_ENABLE_MOTIONFX}
    -DPARAVIEW_USE_MPI:BOOL=${mpi_enabled}
    -DPARAVIEW_USE_OSPRAY:BOOL=${ospray_enabled}
    -DPARAVIEW_ENABLE_VISITBRIDGE:BOOL=${visitbridge_enabled}
    -DVISIT_BUILD_READER_Silo:BOOL=${silo_enabled}
    -DVISIT_BUILD_READER_Boxlib3D:BOOL=${boxlib_enabled}
    -DPARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=${paraview_install_development_files}
    -DPARAVIEW_FREEZE_PYTHON:BOOL=${PARAVIEW_FREEZE_PYTHON}
    -DVTK_MODULE_USE_EXTERNAL_VTK_netcdf:BOOL=${netcdf_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_freetype:BOOL=${freetype_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_hdf5:BOOL=${hdf5_enabled}
    -DHDF5_NO_FIND_PACKAGE_CONFIG_FILE:BOOL=ON
    -DVTK_MODULE_USE_EXTERNAL_VTK_libxml2:BOOL=${libxml2_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_png:BOOL=${png_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_zlib:BOOL=${zlib_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_expat:BOOL=${expat_enabled}
    -DVTK_MODULE_ENABLE_VTK_IOADIOS:BOOL=${adios_module_flag}
    -DVTK_SMP_IMPLEMENTATION_TYPE:STRING=${paraview_smp_backend}
    -DVTK_LEGACY_REMOVE:BOOL=ON
    -DVTK_DEFAULT_RENDER_WINDOW_OFFSCREEN:BOOL=${osmesa_enabled}
    -DVTK_OPENGL_HAS_EGL:BOOL=${egl_enabled}
    -DVTK_OPENGL_HAS_OSMESA:BOOL=${osmesa_enabled}
    -DVTK_USE_X:BOOL=${paraview_use_x}

    # mesa flags
    -DPARAVIEW_WITH_SUPERBUILD_MESA:BOOL=${paraview_mesa_sb_available}
    -DPARAVIEW_WITH_SUPERBUILD_MESA_SWR:BOOL=${mesa_USE_SWR}

    # IndeX
    -DPARAVIEW_PLUGIN_ENABLE_pvNVIDIAIndeX:BOOL=${nvidiaindex_enabled}

    # vrpn
    -DPARAVIEW_PLUGIN_ENABLE_VRPlugin:BOOL=${vrpn_enabled}
    -DPARAVIEW_PLUGIN_VRPlugin_USE_VRPN:BOOL=${vrpn_enabled}

    # vtkm
    -DPARAVIEW_PLUGIN_ENABLE_VTKmFilters:BOOL=${vtkm_enabled}
    -DPARAVIEW_USE_VTKM:BOOL=${vtkm_enabled}
    -DVTK_VTKM_ENABLE_CUDA:BOOL=${paraview_enable_cuda}

    # Web
    -DPARAVIEW_ENABLE_WEB:BOOL=${paraviewweb_enabled}

    # add additional plugin directories
    -DPARAVIEW_EXTERNAL_PLUGIN_DIRS:STRING=${paraview_plugin_dirs}

    ${paraview_extra_cmake_options}

    ${PARAVIEW_EXTRA_CMAKE_ARGUMENTS})

if (DEFINED CMAKE_BUILD_TYPE_save)
  set(CMAKE_BUILD_TYPE "${CMAKE_BUILD_TYPE_save}")
endif ()

if (paraview_install_development_files)
  find_program(SED_EXECUTABLE sed)
  mark_as_advanced(SED_EXECUTABLE)
  if (SED_EXECUTABLE)
    superbuild_project_add_step("fixup-cmake-paths"
      COMMAND "${CMAKE_COMMAND}"
              -Dinstall_location:PATH=<INSTALL_DIR>
              -Dparaview_version:STRING=${paraview_version}
              -P "${CMAKE_CURRENT_LIST_DIR}/scripts/paraview.fixupcmakepaths.cmake"
      COMMENT   "Fixing paths in generated CMake files for packaging."
      DEPENDEES install
      WORKING_DIRECTORY <INSTALL_DIR>)
  endif ()
endif ()

if (paraview_SOURCE_SELECTION STREQUAL "5.3.0")
  superbuild_apply_patch(paraview fix-benchmarks
    "Fix various issues with the shipped benchmark scripts")
  superbuild_apply_patch(paraview fix-vtkconfig-part1
    "Fix various issues with the VTKConfig.cmake (Part 1)")
endif ()

if (paraview_SOURCE_SELECTION STREQUAL "5.5.0")
  superbuild_apply_patch(paraview fix-mpi4py
    "Fix issue with building VTK's mpi4py")
endif ()

if (paraview_SOURCE_SELECTION STREQUAL "5.6.0")
  superbuild_apply_patch(paraview fix-catalyst-adapter-deps
    "Fix issue with catalyst adapters and dependency search")
  superbuild_apply_patch(paraview fix-eye-dome-lighting
    "Fix eye dome lighting in parallel")
endif ()

if (WIN32 AND las_enabled)
  superbuild_append_flags(cxx_flags "-DBOOST_ALL_NO_LIB" PROJECT_ONLY)
endif()


if (APPLE)
  superbuild_append_flags(cxx_flags "-stdlib=libc++" PROJECT_ONLY)
  superbuild_append_flags(ld_flags "-stdlib=libc++" PROJECT_ONLY)
endif ()
