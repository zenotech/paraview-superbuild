ExternalProject_Add(paraview
  PREFIX paraview
  DEPENDS zlib png python freetype hdf5 silo cgns ffmpeg libxml2 qt numpy boost

  GIT_REPOSITORY git://paraview.org/ParaView.git
  GIT_TAG master
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/downloads

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DBUILD_TESTING:BOOL=OFF
    -DCMAKE_INSTALL_PREFIX:PATH=${internal_install_root}
    -DCMAKE_PREFIX_PATH:PATH=${internal_install_root}
    -DPARAVIEW_BUILD_PLUGIN_CoProcessingScriptGenerator:BOOL=ON
    -DPARAVIEW_BUILD_PLUGIN_EyeDomeLighting:BOOL=ON
    -DPARAVIEW_ENABLE_PYTHON:BOOL=ON
    -DPARAVIEW_USE_VISITBRIDGE:BOOL=ON
    -DVISIT_BUILD_READER_CGNS:BOOL=ON
    -DVISIT_BUILD_READER_Silo:BOOL=ON
    -DVTK_USE_BOOST:BOOL=ON
    -DVTK_USE_FFMPEG_ENCODER:BOOL=ON
    -DVTK_USE_SYSTEM_FREETYPE:BOOL=ON
    -DVTK_USE_SYSTEM_HDF5:BOOL=ON
    -DVTK_USE_SYSTEM_LIBXML2:BOOL=ON
    -DVTK_USE_SYSTEM_PNG:BOOL=ON
    -DVTK_USE_SYSTEM_ZLIB:BOOL=ON
    # we are doing this since VTK_USE_SYSTEM_HDF5 doesn't seem set the include
    # paths for HDF5 correctly.
    -DCMAKE_CXX_FLAGS:STRING=${cppflags}
    -DCMAKE_C_FLAGS:STRING=${cppflags}
  INSTALL_COMMAND ""
)
