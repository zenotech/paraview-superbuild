set(PARAVIEW_EXTRA_CMAKE_ARGUMENTS ""
  CACHE STRING "Extra arguments to be passed to ParaView when configuring.")
mark_as_advanced(PARAVIEW_EXTRA_CMAKE_ARGUMENTS)

set(PARAVIEW_BUILD_EDITION "CANONICAL"
  CACHE STRING "Build selected ParaView Edition")
set_property(CACHE PARAVIEW_BUILD_EDITION
  PROPERTY
    STRINGS "CORE;RENDERING;CATALYST;CATALYST_RENDERING;CANONICAL")

set (paraview_extra_cmake_options)
if (PV_NIGHTLY_SUFFIX)
  list(APPEND paraview_extra_cmake_options
    -DPV_NIGHTLY_SUFFIX:STRING=${PV_NIGHTLY_SUFFIX})
endif ()

# Use X only in Linux
set(paraview_use_x ON)
if (WIN32 OR APPLE)
  set(paraview_use_x OFF)
endif()

set(paraview_all_plugins)

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

set(paraview_platform_dependencies)
if (UNIX)
  if (NOT APPLE)
    list(APPEND paraview_platform_dependencies
      mesa
      openxrsdk
      zeromq

      # Needed for fonts to work properly.
      fontconfig)
  endif ()
  list(APPEND paraview_platform_dependencies
    ffmpeg fides fortran libxml2 freetype mili gmsh
    # For cosmotools
    genericio cosmotools)
endif ()

# 5.13 support.
set(paraview_5_13_args)
if (paraview_SOURCE_SELECTION MATCHES "^5\\.13")
  if (UNIX AND NOT APPLE)
    list(APPEND paraview_platform_dependencies
      # OSMesa is only built to support users on bespoke linux systems that do not have an OSMesa library.
      # The OSMesa library/headers are not really required at compile time.
      osmesa
      egl)
    list(APPEND paraview_5_13_args
      -DVTK_DEFAULT_RENDER_WINDOW_OFFSCREEN:BOOL=${osmesa_enabled}
      -DVTK_OPENGL_HAS_EGL:BOOL=${egl_enabled}
      -DVTK_OPENGL_HAS_OSMESA:BOOL=${osmesa_enabled})
  endif ()
endif ()

# 6.0 support.
set(paraview_6_0_0_RC1_args)
if (paraview_SOURCE_SELECTION MATCHES "^6\\.0")
  if (WIN32)
    list(APPEND paraview_6_0_0_RC1_args
      -DViskores_MODULE_ENABLE_viskores_filter_scalar_topology=NO)
  endif ()
endif ()

if (WIN32)
  list(APPEND paraview_platform_dependencies
    openvr openxrremoting openxrsdk zeromq)
endif ()

if (USE_NONFREE_COMPONENTS AND (WIN32 OR (UNIX AND NOT APPLE)))
  list(APPEND paraview_platform_dependencies
    visrtx)
endif ()

set(paraview_use_python ${python3_enabled})
if (python3_enabled AND USE_SYSTEM_python3 AND NOT python3_FIND_LIBRARIES)
  set(paraview_use_python OFF)
endif()

if (expat_enabled)
  list(APPEND paraview_platform_dependencies expat)
endif ()

if (APPLE OR WIN32)
  list(APPEND paraview_platform_dependencies
    threedxwaresdk)
endif ()

cmake_dependent_option(PARAVIEW_INITIALIZE_MPI_ON_CLIENT
  "Initialize MPI on client-processes by default. Can be overridden using command line arguments" ON
  "mpi_enabled" OFF)
mark_as_advanced(PARAVIEW_INITIALIZE_MPI_ON_CLIENT)

if (mpi_enabled)
  list(APPEND paraview_extra_cmake_options
    -DPARAVIEW_INITIALIZE_MPI_ON_CLIENT:BOOL=${PARAVIEW_INITIALIZE_MPI_ON_CLIENT})
endif()

if(APPLE)
  list(APPEND paraview_extra_cmake_options
  -DPARAVIEW_DO_UNIX_STYLE_INSTALLS:BOOL=ON)
endif()
option(PARAVIEW_ENABLE_MOTIONFX "Enable MotionFX reader, if supported on platform" ON)
mark_as_advanced(PARAVIEW_ENABLE_MOTIONFX)
if (NOT PARAVIEW_BUILD_EDITION STREQUAL "CANONICAL")
  set(PARAVIEW_ENABLE_MOTIONFX OFF)
endif ()

option(PARAVIEW_ENABLE_NODEEDITOR "Enable NodeEditor plugin" ON)
mark_as_advanced(PARAVIEW_ENABLE_NODEEDITOR)

option(PARAVIEW_ENABLE_CAVEInteraction "Enable CAVEInteraction plugin" ON)
mark_as_advanced(PARAVIEW_ENABLE_CAVEInteraction)

# vrui support is only available on linux
if (PARAVIEW_ENABLE_CAVEInteraction AND UNIX)
  list(APPEND paraview_extra_cmake_options
    -DPARAVIEW_PLUGIN_CAVEInteraction_USE_VRUI:BOOL=ON
  )
  if (zeromq_enabled)
    set(paraview_vr_collaboration_enabled TRUE)
  else()
    set(paraview_vr_collaboration_enabled FALSE)
  endif()
endif()

set(paraview_use_raytracing OFF)
if (ospray_enabled OR visrtx_enabled)
  set(paraview_use_raytracing ON)
endif ()

# add an option to override ParaView shared-libs flag.
set(BUILD_SHARED_LIBS_paraview "<same>"
  CACHE STRING "The shared/static build flag for the paraview project.")
set_property(CACHE "BUILD_SHARED_LIBS_paraview"
  PROPERTY
    STRINGS "<same>;ON;OFF")
get_property(build_shared_options
  CACHE     "BUILD_SHARED_LIBS_paraview"
  PROPERTY  STRINGS)
if (NOT BUILD_SHARED_LIBS_paraview IN_LIST build_shared_options)
  string(REPLACE ";" ", " build_shared_options "${build_shared_options}")
  message(FATAL_ERROR "BUILD_SHARED_LIBS_paraview must be one of: ${build_shared_options}.")
endif ()

if (BUILD_SHARED_LIBS_paraview STREQUAL "<same>")
  set(paraview_build_shared_libs "${BUILD_SHARED_LIBS}")
else ()
  set(paraview_build_shared_libs "${BUILD_SHARED_LIBS_paraview}")
endif ()

set(PARAVIEW_BUILD_ID "<CI>"
  CACHE STRING "ParaView build ID")
if (PARAVIEW_BUILD_ID STREQUAL "<CI>")
  set(PARAVIEW_BUILD_ID "")
  if ("$ENV{CI}" STREQUAL "true")
    # Detect the status of this CI run.
    set(paraview_commit_sha "$ENV{CI_COMMIT_SHA}")
    if ("$ENV{CI_MERGE_REQUEST_IID}" STREQUAL "")
      set(paraview_mr "")
    else ()
      set(paraview_mr "$ENV{CI_MERGE_REQUEST_IID}")
    endif ()
    if ("$ENV{CI_COMMIT_TAG}" STREQUAL "")
      set(paraview_tag "")
    else ()
      set(paraview_tag "$ENV{CI_COMMIT_TAG}")
    endif ()
    if ("$ENV{CI_COMMIT_BRANCH}" STREQUAL "")
      set(paraview_branch "")
    else ()
      set(paraview_branch "$ENV{CI_COMMIT_BRANCH}")
    endif ()

    if (paraview_mr)
      set(PARAVIEW_BUILD_ID "superbuild ${paraview_commit_sha} (!${paraview_mr})")
    elseif (paraview_tag)
      set(PARAVIEW_BUILD_ID "superbuild ${paraview_commit_sha} (${paraview_tag})")
    elseif (paraview_branch)
      set(PARAVIEW_BUILD_ID "superbuild ${paraview_commit_sha} (${paraview_branch})")
    else ()
      set(PARAVIEW_BUILD_ID "superbuild ${paraview_commit_sha}")
    endif ()
  endif ()
endif ()

if (PARAVIEW_BUILD_ID)
  list(APPEND paraview_extra_cmake_options
    "-DPARAVIEW_BUILD_ID:STRING=${PARAVIEW_BUILD_ID}")
endif ()

if (openvr_enabled)
  set(paraview_vtk_module_openvr_enabled YES)
else()
  set(paraview_vtk_module_openvr_enabled NO)
endif()

if (openxrsdk_enabled)
  set(paraview_vtk_module_openxr_enabled YES)
else()
  set(paraview_vtk_module_openxr_enabled NO)
endif()

if (openxrremoting_enabled)
  set(paraview_vtk_module_openxrremoting_enabled YES)
else()
  set(paraview_vtk_module_openxrremoting_enabled NO)
endif()

if (openvr_enabled OR openxrsdk_enabled)
  set(paraview_xrinterface_plugin_enabled TRUE)
  if (zeromq_enabled)
    set(paraview_vr_collaboration_enabled TRUE)
  else()
    set(paraview_vr_collaboration_enabled FALSE)
  endif()
else ()
  set(paraview_xrinterface_plugin_enabled FALSE)
endif()

if (pdal_enabled AND xerces_enabled)
  set(e57reader_plugin_enabled TRUE)
else()
  set(e57reader_plugin_enabled FALSE)
endif()

if (openvdb_enabled)
  list(APPEND paraview_extra_cmake_options
    -DPARAVIEW_RELOCATABLE_INSTALL:BOOL=OFF)
endif ()

if (qt5_enabled)
  set(paraview_dsp_audio_player "${qt5_ENABLE_MULTIMEDIA}")
  set(paraview_enable_webengine "${qt5_ENABLE_WEBENGINE}")
  set(paraview_qt_enabled "${qt5_enabled}")
endif ()
if (qt6_enabled)
  set(paraview_dsp_audio_player "${qt6_ENABLE_MULTIMEDIA}")
  set(paraview_enable_webengine "${qt6_ENABLE_WEBENGINE}")
  set(paraview_qt_enabled "${qt6_enabled}")
endif ()

superbuild_add_project(paraview
  DEBUGGABLE
  DEFAULT_ON
  DEPENDS cxx11
  DEPENDS_OPTIONAL
    adios2 alembic catalyst cuda boost eigen gdal hdf5 matplotlib mpi numpy pdal png
    protobuf python3 qt qt5 qt6 visitbridge zlib silo las lookingglass pythonmpi4py
    xdmf3 vrpn vtkm netcdf
    cdi
    openturns
    openmp
    openpmd
    openvdb
    nlohmannjson
    paraviewgettingstartedguide
    paraviewtutorialdata paraviewweb
    ${paraview_all_plugins}
    ${paraview_platform_dependencies}
    pythoncftime
    tbb ospray sqlite
    tiff proj exodus seacas
    occt
    libxslt
    ${PARAVIEW_EXTERNAL_PROJECTS}
  CMAKE_ARGS
    -DCMAKE_INSTALL_LIBDIR:PATH=lib
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DCMAKE_MACOSX_RPATH:BOOL=OFF
    -DPARAVIEW_BUILD_LEGACY_REMOVE:BOOL=ON
    -DPARAVIEW_BUILD_SHARED_LIBS:BOOL=${paraview_build_shared_libs}
    -DPARAVIEW_BUILD_TESTING:BOOL=OFF
    -DPARAVIEW_BUILD_EDITION:STRING=${PARAVIEW_BUILD_EDITION}
    -DPARAVIEW_ENABLE_ADIOS2:BOOL=${adios2_enabled}
    -DPARAVIEW_ENABLE_ALEMBIC:BOOL=${alembic_enabled}
    -DPARAVIEW_ENABLE_CATALYST:BOOL=${catalyst_enabled}
    -DPARAVIEW_ENABLE_COSMOTOOLS:BOOL=${cosmotools_enabled}
    -DPARAVIEW_ENABLE_FFMPEG:BOOL=${ffmpeg_enabled}
    -DPARAVIEW_ENABLE_FIDES:BOOL=${fides_enabled}
    -DPARAVIEW_ENABLE_GDAL:BOOL=${gdal_enabled}
    -DPARAVIEW_ENABLE_OPENTURNS:BOOL=${openturns_enabled}
    -DPARAVIEW_ENABLE_PDAL:BOOL=${pdal_enabled}
    -DPARAVIEW_ENABLE_LAS:BOOL=${las_enabled}
    -DPARAVIEW_ENABLE_GEOVIS:BOOL=${proj_enabled}
    -DPARAVIEW_ENABLE_LOOKINGGLASS:BOOL=${lookingglass_enabled}
    -DPARAVIEW_ENABLE_MOTIONFX:BOOL=${PARAVIEW_ENABLE_MOTIONFX}
    -DPARAVIEW_ENABLE_OCCT:BOOL=${occt_enabled}
    -DPARAVIEW_ENABLE_VISITBRIDGE:BOOL=${visitbridge_enabled}
    -DPARAVIEW_ENABLE_XDMF3:BOOL=${xdmf3_enabled}
    -DPARAVIEW_GENERATE_SPDX:BOOL=${GENERATE_SPDX}
    -DPARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=ON
    -DPARAVIEW_PLUGIN_ENABLE_E57PDALReader:BOOL=${e57reader_plugin_enabled}
    -DPARAVIEW_PLUGIN_ENABLE_EnSightGoldCombinedReader:BOOL=ON
    -DPARAVIEW_PLUGIN_ENABLE_GmshIO:BOOL=${gmsh_enabled}
    -DPARAVIEW_PLUGIN_ENABLE_LookingGlass:BOOL=${lookingglass_enabled}
    -DPARAVIEW_PLUGIN_ENABLE_NodeEditor:BOOL=${PARAVIEW_ENABLE_NODEEDITOR}
    -DPARAVIEW_PLUGIN_dsp_enable_audio_player:BOOL=${paraview_dsp_audio_player}
    -DPARAVIEW_PLUGIN_ENABLE_XRInterface:BOOL=${paraview_xrinterface_plugin_enabled}
    -DPARAVIEW_PLUGIN_ENABLE_zSpace:BOOL=${zspace_enabled}
    -DPARAVIEW_PLUGIN_ENABLE_NetCDFTimeAnnotationPlugin:BOOL=${pythoncftime_enabled}
    -DPARAVIEW_XRInterface_OpenVR_Support:BOOL=${openvr_enabled}
    -DPARAVIEW_XRInterface_OpenXR_Support:BOOL=${openxrsdk_enabled}
    -DPARAVIEW_XRInterface_OpenXRRemoting_Support:BOOL=${openxrremoting_enabled}
    -DVTK_MODULE_ENABLE_VTK_RenderingOpenVR:STRING=${paraview_vtk_module_openvr_enabled}
    -DVTK_MODULE_ENABLE_VTK_RenderingOpenXR:STRING=${paraview_vtk_module_openxr_enabled}
    -DVTK_MODULE_ENABLE_VTK_RenderingOpenXRRemoting:STRING=${paraview_vtk_module_openxrremoting_enabled}
    -DPARAVIEW_PYTHON_VERSION:STRING=3
    -DPARAVIEW_USE_MPI:BOOL=${mpi_enabled}
    -DPARAVIEW_USE_FORTRAN:BOOL=${fortran_enabled}
    -DPARAVIEW_USE_PYTHON:BOOL=${paraview_use_python}
    -DPARAVIEW_USE_QT:BOOL=${paraview_qt_enabled}
    -DPARAVIEW_USE_SERIALIZATION:BOOL=ON
    -DPARAVIEW_QT_VERSION:STRING=${qt_version}
    -DVTK_QT_VERSION:STRING=${qt_version}
    -DVISIT_BUILD_READER_Mili:BOOL=${mili_enabled}
    -DVISIT_BUILD_READER_Silo:BOOL=${silo_enabled}
    -DVTK_ENABLE_VR_COLLABORATION:BOOL=${paraview_vr_collaboration_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_eigen=${eigen_enabled}
    -DVTK_MODULE_USE_EXTERNAL_ParaView_protobuf:BOOL=${protobuf_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_exodus:BOOL=${exodus_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_expat:BOOL=${expat_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_freetype:BOOL=${freetype_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_hdf5:BOOL=${hdf5_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_libproj:BOOL=${proj_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_libxml2:BOOL=${libxml2_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_mpi4py:BOOL=${pythonmpi4py_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_netcdf:BOOL=${netcdf_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_png:BOOL=${png_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_sqlite:BOOL=${sqlite_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_tiff:BOOL=${tiff_enabled}
    -DVTK_MODULE_USE_EXTERNAL_VTK_zlib:BOOL=${zlib_enabled}
    ${paraview_5_13_args}
    ${paraview_6_0_0_RC1_args}
    -DVTK_SMP_IMPLEMENTATION_TYPE:STRING=${paraview_smp_backend}
    -DVTK_SMP_ENABLE_TBB:BOOL=${tbb_enabled}
    -DVTK_SMP_ENABLE_OPENMP:BOOL=${openmp_enabled}
    -DVTK_SMP_ENABLE_STDTHREAD:BOOL=ON
    -DVTK_SMP_ENABLE_SEQUENTIAL:BOOL=ON
    -DVTK_USE_X:BOOL=${paraview_use_x}

    # raytracing flags
    -DPARAVIEW_ENABLE_RAYTRACING:BOOL=${paraview_use_raytracing}
    -DVTKOSPRAY_ENABLE_DENOISER:BOOL=${openimagedenoise_enabled}
    -DVTK_ENABLE_OSPRAY:BOOL=${ospray_enabled}
    -DVTK_ENABLE_VISRTX:BOOL=${visrtx_enabled}

    # IndeX
    -DPARAVIEW_PLUGIN_ENABLE_pvNVIDIAIndeX:BOOL=${nvidiaindex_enabled}

    # vrpn
    -DPARAVIEW_PLUGIN_ENABLE_CAVEInteraction:BOOL=${PARAVIEW_ENABLE_CAVEInteraction}
    -DPARAVIEW_PLUGIN_CAVEInteraction_USE_VRPN:BOOL=${vrpn_enabled}

    # vtkm
    -DPARAVIEW_PLUGIN_ENABLE_VTKmFilters:BOOL=${vtkm_enabled}
    -DPARAVIEW_USE_VTKM:BOOL=${vtkm_enabled}
    -DVTK_VTKM_ENABLE_CUDA:BOOL=${paraview_enable_cuda}

    # Web
    -DPARAVIEW_ENABLE_WEB:BOOL=${paraviewweb_enabled}
    -DPARAVIEW_ENABLE_QTWEBENGINE:BOOL=${paraview_enable_webengine}

    # Readers
    -DVTK_MODULE_ENABLE_VTK_IOSegY:STRING=YES
    -DVTK_MODULE_ENABLE_VTK_IOCesium3DTiles:STRING=YES

    # ParFlow
    -DPARAVIEW_PLUGIN_ENABLE_ParFlow:BOOL=${nlohmannjson_enabled}

    # OpenVDB (not in ParaView v5.9.1 but in master)
    -DPARAVIEW_ENABLE_OPENVDB:BOOL=${openvdb_enabled}

    # 3Dconnexion SpaceMouse
    -DPARAVIEW_PLUGIN_ENABLE_SpaceMouseInteractor:BOOL=${threedxwaresdk_enabled}

    # CDI Reader
    -DPARAVIEW_PLUGIN_ENABLE_CDIReader:BOOL=${cdi_enabled}

    # Implicit array support in dispatcher
    # Needed for the DSP plugin
    -DVTK_DISPATCH_CONSTANT_ARRAYS:BOOl=ON

    ${paraview_extra_cmake_options}

    ${PARAVIEW_EXTRA_CMAKE_ARGUMENTS})

if (DEFINED CMAKE_BUILD_TYPE_save)
  set(CMAKE_BUILD_TYPE "${CMAKE_BUILD_TYPE_save}")
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

if (ospray_enabled AND tbb_enabled)
  superbuild_add_extra_cmake_args(
    -DTBB_ROOT:PATH=<INSTALL_DIR>)
endif()

if (paraview_SOURCE_SELECTION MATCHES "^5.12")
  # Remove bogus interface directory from VTK-m's loguru third party.
  # https://gitlab.kitware.com/vtk/vtk-m/-/merge_requests/3163
  # https://gitlab.kitware.com/paraview/paraview-superbuild/-/issues/264
  superbuild_apply_patch(paraview 5.12-vtkm-loguru-install-interface
    "Remove non-existent include directory from VTK-m's loguru target")
endif ()
