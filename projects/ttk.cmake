# the TTK_CUSTOM_FILTERS is a semicolon separeted list of filters
# specifed by the user and containing additional TTK filters to build

# Modules
# -------

# core modules
set(TTK_CORE_FILTER_LIST)

if (UNIX)
  find_package(OpenMP COMPONENTS CXX)
  set(TTK_ENABLE_OPENMP ${OpenMP_CXX_FOUND})
else ()
  # no openmp on windows because too old
  set(TTK_ENABLE_OPENMP FALSE)
endif()

list(APPEND TTK_CORE_FILTER_LIST
  -DVTK_MODULE_ENABLE_ttkAlgorithm=YES
  -DVTK_MODULE_ENABLE_ttkTriangulationAlgorithm=YES
  -DVTK_MODULE_ENABLE_ttkProgramBase=YES
)

# tests
list(APPEND TTK_CORE_FILTER_LIST
  -DVTK_MODULE_ENABLE_ttkBlank=YES
  -DVTK_MODULE_ENABLE_ttkHelloWorld=YES
)

# utility
list(APPEND TTK_CORE_FILTER_LIST
  -DVTK_MODULE_ENABLE_ttkArrayEditor=YES
  -DVTK_MODULE_ENABLE_ttkArrayPreconditioning=YES
  -DVTK_MODULE_ENABLE_ttkBlockAggregator=YES
  -DVTK_MODULE_ENABLE_ttkDataSetToTable=YES
  -DVTK_MODULE_ENABLE_ttkExtract=YES
  -DVTK_MODULE_ENABLE_ttkForEach=YES
  -DVTK_MODULE_ENABLE_ttkEndFor=YES
  -DVTK_MODULE_ENABLE_ttkGridLayout=YES
  -DVTK_MODULE_ENABLE_ttkIcosphere=YES
  -DVTK_MODULE_ENABLE_ttkIcosphereFromObject=YES
  -DVTK_MODULE_ENABLE_ttkIcospheresFromPoints=YES
  -DVTK_MODULE_ENABLE_ttkIdentifierRandomizer=YES
  -DVTK_MODULE_ENABLE_ttkPointDataSelector=YES
  -DVTK_MODULE_ENABLE_ttkScalarFieldNormalizer=YES
  -DVTK_MODULE_ENABLE_ttkScalarFieldSmoother=YES
  -DVTK_MODULE_ENABLE_ttkTextureMapFromField=YES
)

# topology
list(APPEND TTK_CORE_FILTER_LIST
  -DVTK_MODULE_ENABLE_ttkContinuousScatterPlot=YES
  -DVTK_MODULE_ENABLE_ttkContourAroundPoint=YES
  -DVTK_MODULE_ENABLE_ttkContourTreeAlignment=YES
  -DVTK_MODULE_ENABLE_ttkFTMTree=YES
  -DVTK_MODULE_ENABLE_ttkFTRGraph=YES
  -DVTK_MODULE_ENABLE_ttkFiber=YES
  -DVTK_MODULE_ENABLE_ttkFiberSurface=YES
  -DVTK_MODULE_ENABLE_ttkPersistenceCurve=YES
  -DVTK_MODULE_ENABLE_ttkPersistenceDiagram=YES
  -DVTK_MODULE_ENABLE_ttkIntegralLines=YES
  -DVTK_MODULE_ENABLE_ttkJacobiSet=YES
  -DVTK_MODULE_ENABLE_ttkMeshGraph=YES
  -DVTK_MODULE_ENABLE_ttkMorseSmaleComplex=YES
  -DVTK_MODULE_ENABLE_ttkPeriodicGrid=YES
  -DVTK_MODULE_ENABLE_ttkPlanarGraphLayout=YES
  -DVTK_MODULE_ENABLE_ttkReebSpace=YES
  -DVTK_MODULE_ENABLE_ttkScalarFieldCriticalPoints=YES
  -DVTK_MODULE_ENABLE_ttkTopologicalSimplification=YES
  -DVTK_MODULE_ENABLE_ttkTrackingFromFields=YES
  -DVTK_MODULE_ENABLE_ttkTrackingFromOverlap=YES
  -DVTK_MODULE_ENABLE_ttkTrackingFromPersistenceDiagrams=YES
)

# geometry processing
list(APPEND TTK_CORE_FILTER_LIST
  -DVTK_MODULE_ENABLE_ttkDepthImageBasedApproximation=YES
  -DVTK_MODULE_ENABLE_ttkDistanceField=YES
  -DVTK_MODULE_ENABLE_ttkGeometrySmoother=YES
  -DVTK_MODULE_ENABLE_ttkManifoldCheck=YES
  -DVTK_MODULE_ENABLE_ttkMorseSmaleQuadrangulation=YES
  -DVTK_MODULE_ENABLE_ttkProjectionFromField=YES
  -DVTK_MODULE_ENABLE_ttkQuadrangulationSubdivision=YES
)
if (eigen_enabled)
  list(APPEND TTK_CORE_FILTER_LIST
    -DVTK_MODULE_ENABLE_ttkEigenField=YES
    -DVTK_MODULE_ENABLE_ttkHarmonicField=YES
  )
endif()

# clustering
list(APPEND TTK_CORE_FILTER_LIST
  -DVTK_MODULE_ENABLE_ttkPersistenceDiagramClustering=YES
)

# higher dimensions

# ensemble
list(APPEND TTK_CORE_FILTER_LIST
  -DVTK_MODULE_ENABLE_ttkMandatoryCriticalPoints=YES
  -DVTK_MODULE_ENABLE_ttkDimensionReduction=YES
)

# cinema
list(APPEND TTK_CORE_FILTER_LIST
  -DVTK_MODULE_ENABLE_ttkCinemaReader=YES
  -DVTK_MODULE_ENABLE_ttkCinemaWriter=YES
  -DVTK_MODULE_ENABLE_ttkCinemaQuery=YES
  -DVTK_MODULE_ENABLE_ttkCinemaImaging=YES
  -DVTK_MODULE_ENABLE_ttkCinemaProductReader=YES
  -DVTK_MODULE_ENABLE_ttkCinemaDarkroom=YES
)

# compression
list(APPEND TTK_CORE_FILTER_LIST
  -DVTK_MODULE_ENABLE_ttkTopologicalCompressionReader=YES
  -DVTK_MODULE_ENABLE_ttkTopologicalCompressionWriter=YES
)

# user defined modules
foreach(TTK_MODULE IN LISTS TTK_CUSTOM_FILTERS)
  list(APPEND TTK_CORE_FILTER_LIST -DVTK_MODULE_ENABLE_${TTK_MODULE}=YES)
endforeach()

# install location
if(UNIX)
  set(TTK_INSTALL_PLUGIN_DIR "lib/paraview-${paraview_version}/plugins/")
else()
  # windows
  set(TTK_INSTALL_PLUGIN_DIR "bin/paraview-${paraview_version}/plugins/")
endif()


# Build
# -----

# TODO: enable embree, for now
# there is a missing embree3/rtcore.h
superbuild_add_project(ttk
  DEPENDS paraview boost cxx11
  DEPENDS_OPTIONAL zlib python numpy scipy zfp eigen
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DTTK_BUILD_STANDALONE_APPS:BOOL=FALSE
    -DCMAKE_INSTALL_LIBDIR:PATH=lib
    -DCMAKE_INSTALL_RPATH:PATH=lib
    -DTTK_INSTALL_PLUGIN_DIR:PATH=${TTK_INSTALL_PLUGIN_DIR}

    -DTTK_ENABLE_KAMIKAZE:BOOL=TRUE
    -DTTK_ENABLE_CPU_OPTIMIZATION:BOOL=FALSE
    -DTTK_ENABLE_DOUBLE_TEMPLATING:BOOL=ON
    -DTTK_ENABLE_EMBREE:BOOL=NO
    -DTTK_ENABLE_OPENMP:BOOL=${TTK_ENABLE_OPENMP}
    -DTTK_ENABLE_EIGEN:BOOL=${eigen_enabled}
    -DTTK_ENABLE_ZFP:BOOL=${zfp_enabled}

    -DTTK_WHITELIST_MODE:BOOL=TRUE
    ${TTK_CORE_FILTER_LIST}
  )
