set (build_qt_gui)
if (${ENABLE_QT} AND NOT ${PV_COMMAND_LINE_TOOLS_ONLY})
  set (build_qt_gui TRUE)
else()
  set (build_qt_gui FALSE)
endif()

set (dependencies
  zlib png freetype hdf5 silo cgns ffmpeg libxml2 boost)

if (ENABLE_PYTHON)
  set (dependencies ${dependencies} python)
endif()

if (ENABLE_NUMPY)
  set (dependencies ${dependencies} numpy)
endif ()

if (ENABLE_QT)
  set (dependencies ${dependencies} qt)
endif()

if (ENABLE_MANTA)
  set (dependencies ${dependencies} manta)
endif()

if (ENABLE_MPICH2)
  set (dependencies ${dependencies} mpich2)
endif ()

add_external_project(paraview
  DEPENDS ${dependencies}

  GIT_REPOSITORY git://paraview.org/ParaView.git
  GIT_TAG master

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DBUILD_TESTING:BOOL=OFF
    -DPARAVIEW_BUILD_PLUGIN_CoProcessingScriptGenerator:BOOL=ON
    -DPARAVIEW_BUILD_PLUGIN_EyeDomeLighting:BOOL=ON
    -DPARAVIEW_BUILD_PLUGIN_Manta:BOOL=${ENABLE_MANTA}
    -DPARAVIEW_BUILD_QT_GUI:BOOL=${build_qt_gui}
    -DPARAVIEW_ENABLE_PYTHON:BOOL=${ENABLE_PYTHON}
    -DPARAVIEW_USE_MPI:BOOL=${ENABLE_MPICH2}
    -DPARAVIEW_USE_VISITBRIDGE:BOOL=ON
    -DVISIT_BUILD_READER_CGNS:BOOL=${ENABLE_CGNS}
    -DVISIT_BUILD_READER_Silo:BOOL=${ENABLE_SILO}
    -DVTK_USE_BOOST:BOOL=${ENABLE_BOOST}
    -DVTK_USE_FFMPEG_ENCODER:BOOL=${ENABLE_FFMPEG}
    -DVTK_USE_QT:BOOL=${ENABLE_QT}
    -DVTK_USE_SYSTEM_FREETYPE:BOOL=${ENABLE_FREETYPE}
    -DVTK_USE_SYSTEM_HDF5:BOOL=${ENABLE_HDF5}
    -DVTK_USE_SYSTEM_LIBXML2:BOOL=${ENABLE_LIBXML2}
    -DVTK_USE_SYSTEM_PNG:BOOL=${ENABLE_PNG}
    -DVTK_USE_SYSTEM_ZLIB:BOOL=${ENABLE_ZLIB}
    # this needs to be set (alas!) since FindFREETYPE.cmake doesn't respect
    # CMAKE_PREFIX_PATH
    # this won't be needed once the fir for BUG #12688 makes it to master.
    -DFREETYPE_INCLUDE_DIR_FTHEADER:PATH=<INSTALL_DIR>/include/freetype2/

    -DMANTA_BUILD:PATH=${ParaViewSuperBuild_BINARY_DIR}/manta/src/manta-build
)
