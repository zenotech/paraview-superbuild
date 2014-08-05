set(PARAVIEW_MODULES_TO_ENABLE "" CACHE STRING
    "Specify modules to enable separated by ';' e.g.  vtkIOXML;vtkFiltersProgrammable")

set(enabled_vtk_modules)
if(PARAVIEW_MODULES_TO_ENABLE)
  foreach(module ${PARAVIEW_MODULES_TO_ENABLE})
    set(enabled_vtk_modules
      ${enabled_vtk_modules}
      -DModule_${module}:BOOL=ON)
  endforeach()
endif()

set(64bit_build FALSE)
set (PARAVIEW_OPTIONS
  -DBUILD_SHARED_LIBS:BOOL=OFF
  -DBUILD_TESTING:BOOL=OFF
  -DPARAVIEW_BUILD_QT_GUI:BOOL=OFF
  -DVTK_USE_SYSTEM_MPI4PY:BOOL=ON
  -DPARAVIEW_USE_VISITBRIDGE:BOOL=ON

  -DPARAVIEW_USE_MPI:BOOL=ON

  # We need to use system HDF5 which is MPI enabled (with system zlib). Hence we
  # 1. extend HDF5_C_INLCUDE_DIR to include the MPI include dirs.
  # 2. Use system zlib
  -DVTK_USE_SYSTEM_HDF5:BOOL=ON
  -DVTK_USE_SYSTEM_ZLIB:BOOL=ON

  # check is this is passed on to the ParaView CMake correctly. In my build the
  # separators were misssing!!!
  -DHDF5_C_INCLUDE_DIR:PATH=/opt/share/hdf5/1.8.9/bgp-gcc/include${ep_list_separator}/bgsys/drivers/V1R4M2_200_2010-100508P/ppc/comm/default/include${ep_list_separator}/bgsys/drivers/V1R4M2_200_2010-100508P/ppc/comm/sys/include
  -DHDF5_hdf5_LIBRARY:FILEPATH=/opt/share/hdf5/1.8.9/bgp-gcc/lib/libhdf5.a
  -DHDF5_hdf5_hl_LIBRARY:FILEPATH=/opt/share/hdf5/1.8.9/bgp-gcc/lib/libhdf5_hl.a
  -DHDF5_hdf5_hl_LIBRARY_DEBUG:FILEPATH=/opt/share/hdf5/1.8.9/bgp-gcc/lib/libhdf5_hl.a
  -DHDF5_hdf5_hl_LIBRARY_RELEASE:FILEPATH=/opt/share/hdf5/1.8.9/bgp-gcc/lib/libhdf5_hl.a
  -DZLIB_INCLUDE_DIR:PATH=/opt/share/zlib/1.2.5/bgp-gcc/include
  -DZLIB_LIBRARY:FILEPATH=/opt/share/zlib/1.2.5/bgp-gcc/lib/libz.a

   # Disable plugins.
  -DPARAVIEW_BUILD_PLUGIN_AdiosReader:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_AnalyzeNIfTIIO:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_ArrowGlyph:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_CoProcessingScriptGenerator:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_EyeDomeLighting:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_ForceTime:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_GMVReader:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_H5PartReader:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_MantaView:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_Moments:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_Nektar:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_NonOrthogonalSource:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_PacMan:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_PointSprite:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_PrismPlugin:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_QuadView:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_SLACTools:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_SciberQuestToolKit:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_SierraPlotTools:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_SurfaceLIC:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_UncertaintyRendering:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_VaporPlugin:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_pvblot:BOOL=OFF
  -DPARAVIEW_BUILD_PLUGIN_StreamingParticles:BOOL=OFF

  # Disable automatic enabling of VTK modules. We manually select VTK modules
  # that need to be enabled.
  -DPARAVIEW_ENABLE_VTK_MODULES_AS_NEEDED:BOOL=OFF

  ${enabled_vtk_modules}
)
