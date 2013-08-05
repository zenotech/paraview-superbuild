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

if (APPLE)
  # We are having issues building mpi4py with Python 2.6 on Mac OSX. Hence,
  # disable it for now.
  list (APPEND extra_cmake_args
        -DPARAVIEW_USE_SYSTEM_MPI4PY:BOOL=ON)
endif()

set (PARAVIEW_INSTALL_DEVELOPMENT_FILES FALSE)
if (paraviewsdk_ENABLED)
  set (PARAVIEW_INSTALL_DEVELOPMENT_FILES TRUE)
endif()

add_external_project(paraview
  DEPENDS_OPTIONAL
    boost ffmpeg hdf5 libxml3 manta matplotlib mpi numpy png python qt visitbridge zlib silo cgns
    mesa osmesa nektarreader

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DBUILD_TESTING:BOOL=OFF
    -DPARAVIEW_BUILD_PLUGIN_CoProcessingScriptGenerator:BOOL=ON
    -DPARAVIEW_BUILD_PLUGIN_EyeDomeLighting:BOOL=ON
    -DPARAVIEW_BUILD_PLUGIN_MantaView:BOOL=${manta_ENABLED}
    -DPARAVIEW_BUILD_QT_GUI:BOOL=${qt_ENABLED}
    -DPARAVIEW_ENABLE_FFMPEG:BOOL=${ffmpeg_ENABLED}
    -DPARAVIEW_ENABLE_PYTHON:BOOL=${python_ENABLED}
    -DPARAVIEW_USE_MPI:BOOL=${mpi_ENABLED}
    -DPARAVIEW_USE_VISITBRIDGE:BOOL=${visitbridge_ENABLED}
    -DVISIT_BUILD_READER_CGNS:BOOL=${cgns_ENABLED}
    -DVISIT_BUILD_READER_Silo:BOOL=${silo_ENABLED}
    -DVTK_USE_SYSTEM_HDF5:BOOL=${hdf5_ENABLED}
    -DPARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=${PARAVIEW_INSTALL_DEVELOPMENT_FILES}
    -DPARAVIEW_BUILD_PLUGIN_Nektar:BOOL=${nektarreader_ENABLED}
    # since VTK mangles all the following, I wonder if there's any point in
    # making it use system versions.
#    -DVTK_USE_SYSTEM_FREETYPE:BOOL=${ENABLE_FREETYPE}
#    -DVTK_USE_SYSTEM_LIBXML2:BOOL=${ENABLE_LIBXML2}
#    -DVTK_USE_SYSTEM_PNG:BOOL=${ENABLE_PNG}
#    -DVTK_USE_SYSTEM_ZLIB:BOOL=${ENABLE_ZLIB}

    # Web documentation
    -DPARAVIEW_BUILD_WEB_DOCUMENTATION:BOOL=${PARAVIEW_BUILD_WEB_DOCUMENTATION}

    # specify the apple app install prefix. No harm in specifying it for all
    # platforms.
    -DMACOSX_APP_INSTALL_PREFIX:PATH=<INSTALL_DIR>/Applications

  ${extra_cmake_args}

  ${PV_EXTRA_CMAKE_ARGS}
)
