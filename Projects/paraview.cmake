set(PV_EXTRA_CMAKE_ARGS ""
    CACHE STRING "Extra arguments to be passed to ParaView when configuring.")
mark_as_advanced(PV_EXTRA_CMAKE_ARGS)

set (extra_cmake_args)
if (manta_ENABLED)
  list (APPEND extra_cmake_args
    -DMANTA_BUILD:PATH=${SuperBuild_BINARY_DIR}/manta/src/manta-build)
endif()
if(PV_NIGHTLY_SUFFIX)
  list (APPEND extra_cmake_args
    -DPV_NIGHTLY_SUFFIX:STRING=${PV_NIGHTLY_SUFFIX})
endif()

set (PARAVIEW_INSTALL_DEVELOPMENT_FILES FALSE)
if (paraviewsdk_ENABLED)
  set (PARAVIEW_INSTALL_DEVELOPMENT_FILES TRUE)
endif()

set(osmesa_ARGS)
if(osmesa_ENABLED)
  set(osmesa_ARGS -DVTK_OPENGL_HAS_OSMESA:BOOL=ON -DVTK_USE_X:BOOL=OFF)
endif()

set(use_qt OFF)
if (qt4_ENABLED OR qt5_ENABLED)
  set(use_qt ON)
endif ()

set(PARAVIEW_RENDERING_BACKEND "OpenGL" CACHE STRING "Rendering backend to use for ParaView")
set_property(CACHE PARAVIEW_RENDERING_BACKEND
  PROPERTY
    STRINGS "OpenGL;OpenGL2")

get_property(plugins GLOBAL PROPERTY pv_plugins)
list (REMOVE_DUPLICATES plugins)

set(plugin_dirs)
foreach (plugin IN LISTS plugins)
  if (${plugin}_ENABLED AND TARGET ${plugin})
      get_property(plugin_dir TARGET "${plugin}" PROPERTY _EP_SOURCE_DIR)
      set(plugin_dirs "${plugin_dir}$<SEMICOLON>${plugin_dirs}")
  endif ()
endforeach ()

if (NOT CMAKE_CONFIGURATION_TYPES AND NOT WIN32)
  set(PARAVIEW_BUILD_TYPE "" CACHE STRING "Paraview's build mode")
  mark_as_advanced(PARAVIEW_BUILD_TYPE)
  if (NOT PARAVIEW_BUILD_TYPE)
    set(PARAVIEW_BUILD_TYPE "${CMAKE_BUILD_TYPE}")
  endif ()

  set(CMAKE_BUILD_TYPE_save "${CMAKE_BUILD_TYPE}")
  set(CMAKE_BUILD_TYPE "${PARAVIEW_BUILD_TYPE}")
endif ()

set(VTK_SMP_IMPLEMENTATION_TYPE "Sequential")
if (tbb_ENABLED)
  set(VTK_SMP_IMPLEMENTATION_TYPE "TBB")
endif ()

add_external_project(paraview
  DEPENDS_OPTIONAL
    adios boost cosmotools ffmpeg hdf5 libxml3 manta matplotlib mpi numpy png python qt4 qt5 visitbridge zlib silo cgns xdmf3
    mesa osmesa nektarreader netcdf vrpn tbb
    ${PV_EXTERNAL_PROJECTS} ${plugins}

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_TESTING:BOOL=OFF
    -DPARAVIEW_BUILD_PLUGIN_CoProcessingScriptGenerator:BOOL=ON
    -DPARAVIEW_BUILD_PLUGIN_EyeDomeLighting:BOOL=ON
    -DPARAVIEW_BUILD_PLUGIN_MantaView:BOOL=${manta_ENABLED}
    -DPARAVIEW_BUILD_QT_GUI:BOOL=${use_qt}
    -DPARAVIEW_ENABLE_FFMPEG:BOOL=${ffmpeg_ENABLED}
    -DPARAVIEW_ENABLE_PYTHON:BOOL=${python_ENABLED}
    -DPARAVIEW_ENABLE_COSMOTOOLS:BOOL=${cosmotools_ENABLED}
    -DPARAVIEW_USE_MPI:BOOL=${mpi_ENABLED}
    -DPARAVIEW_USE_VISITBRIDGE:BOOL=${visitbridge_ENABLED}
    -DPARAVIEW_ENABLE_XDMF3:BOOL=${xdmf3_ENABLED}
    -DVISIT_BUILD_READER_CGNS:BOOL=OFF # force to off
    -DPARAVIEW_ENABLE_CGNS:BOOL=${cgns_ENABLED}
    -DVISIT_BUILD_READER_Silo:BOOL=${silo_ENABLED}
    -DPARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=${PARAVIEW_INSTALL_DEVELOPMENT_FILES}
    -DPARAVIEW_BUILD_PLUGIN_Nektar:BOOL=${nektarreader_ENABLED}
    -DPARAVIEW_ENABLE_MATPLOTLIB:BOOL=${matplotlib_ENABLED}
    -DVTK_USE_SYSTEM_NETCDF:BOOL=${netcdf_ENABLED}
    -DVTK_USE_SYSTEM_FREETYPE:BOOL=${freetype_ENABLED}
    -DVTK_USE_SYSTEM_HDF5:BOOL=${hdf5_ENABLED}
    -DVTK_USE_SYSTEM_LIBXML2:BOOL=${libxml2_ENABLED}
    -DVTK_USE_SYSTEM_PNG:BOOL=${png_ENABLED}
    -DVTK_USE_SYSTEM_ZLIB:BOOL=${zlib_ENABLED}
    -DModule_vtkIOADIOS:BOOL=${adios_ENABLED}
    -DVTK_RENDERING_BACKEND:STRING=${PARAVIEW_RENDERING_BACKEND}
    -DVTK_SMP_IMPLEMENTATION_TYPE:STRING=${VTK_SMP_IMPLEMENTATION_TYPE}
    ${osmesa_ARGS}

    # vrpn
    -DPARAVIEW_BUILD_PLUGIN_VRPlugin:BOOL=${vrpn_ENABLED}
    -DPARAVIEW_USE_VRPN:BOOL=${vrpn_ENABLED}

    # Web documentation
    -DPARAVIEW_BUILD_WEB_DOCUMENTATION:BOOL=${PARAVIEW_BUILD_WEB_DOCUMENTATION}

    # specify the apple app install prefix. No harm in specifying it for all
    # platforms.
    -DMACOSX_APP_INSTALL_PREFIX:PATH=<INSTALL_DIR>/Applications

    # add additional plugin directories
    -DPARAVIEW_EXTERNAL_PLUGIN_DIRS:STRING=${plugin_dirs}

    ${extra_cmake_args}

  ${PV_EXTRA_CMAKE_ARGS}
)

if (DEFINED CMAKE_BUILD_TYPE_save)
  set(CMAKE_BUILD_TYPE "${CMAKE_BUILD_TYPE_save}")
endif ()
