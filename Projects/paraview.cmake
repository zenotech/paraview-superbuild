set (extra_cmake_args)
if (manta_ENABLED)
  list (APPEND extra_cmake_args
    -DMANTA_BUILD:PATH=${ParaViewSuperBuild_BINARY_DIR}/manta/src/manta-build)
endif()

add_external_project(paraview
  DEPENDS_OPTIONAL
     zlib png hdf5 silo cgns ffmpeg libxml2 boost python numpy
     mpich2 manta qt

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DBUILD_TESTING:BOOL=OFF
    -DPARAVIEW_BUILD_PLUGIN_CoProcessingScriptGenerator:BOOL=ON
    -DPARAVIEW_BUILD_PLUGIN_EyeDomeLighting:BOOL=ON
    -DPARAVIEW_BUILD_PLUGIN_Manta:BOOL=${manta_ENABLED}
    -DPARAVIEW_BUILD_QT_GUI:BOOL=${qt_ENABLED}
    -DPARAVIEW_ENABLE_FFMPEG:BOOL=${ffmpeg_ENABLED}
    -DPARAVIEW_ENABLE_PYTHON:BOOL=${python_ENABLED}
    -DPARAVIEW_USE_MPI:BOOL=${mpich2_ENABLED}
    -DPARAVIEW_USE_VISITBRIDGE:BOOL=ON
    -DVISIT_BUILD_READER_CGNS:BOOL=${cgns_ENABLED}
    -DVISIT_BUILD_READER_Silo:BOOL=${silo_ENABLED}
    -DVTK_USE_BOOST:BOOL=${boost_ENABLED}
    -DVTK_USE_SYSTEM_HDF5:BOOL=${hdf5_ENABLED}
    # since VTK mangles all the following, I wonder if there's any point in
    # making it use system versions.
#    -DVTK_USE_SYSTEM_FREETYPE:BOOL=${ENABLE_FREETYPE}
#    -DVTK_USE_SYSTEM_LIBXML2:BOOL=${ENABLE_LIBXML2}
#    -DVTK_USE_SYSTEM_PNG:BOOL=${ENABLE_PNG}
#    -DVTK_USE_SYSTEM_ZLIB:BOOL=${ENABLE_ZLIB}

    # specify the apple app install prefix. No harm in specifying it for all
    # platforms.
    -DMACOSX_APP_INSTALL_PREFIX:PATH=<INSTALL_DIR>/Applications

  ${extra_cmake_args}

  LIST_SEPARATOR +
)
