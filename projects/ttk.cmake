# the ttk_CUSTOM_FILTERS is a semicolon separeted list of filters
# specifed by the user and containing additional TTK filters to build

# Modules
# -------

set(ttk_enabled_modules
  # core modules
  ttkAlgorithm
  ttkTriangulationAlgorithm
  ttkProgramBase

  # tests
  ttkHelloWorld
  ttkTriangulationManager
  ttkTriangulationRequest

  # utility
  ttkArrayEditor
  ttkArrayPreconditioning
  ttkBlockAggregator
  ttkExtract
  ttkFlattenMultiBlock
  ttkForEach
  ttkEndFor
  ttkGridLayout
  ttkIcosphere
  ttkIcosphereFromObject
  ttkIcospheresFromPoints
  ttkIdentifierRandomizer
  ttkIdentifyByScalarField
  ttkPointDataSelector
  ttkPointSetToCurve
  ttkScalarFieldNormalizer
  ttkScalarFieldSmoother
  ttkTextureMapFromField

  # topology
  ttkContinuousScatterPlot
  ttkContourAroundPoint
  ttkContourTree
  ttkContourTreeAlignment
  ttkFiber
  ttkFiberSurface
  ttkFTMTree
  ttkFTRGraph
  ttkIntegralLines
  ttkJacobiSet
  ttkMergeTreePrincipalGeodesics
  ttkMergeTreePrincipalGeodesicsDecoding
  ttkMergeTreePrincipalGeodesicsDecoding_PathTrees
  ttkMergeTreePrincipalGeodesicsDecoding_Surface
  ttkMergeTreeTemporalReductionDecoding
  ttkMergeTreeTemporalReductionEncoding
  ttkMeshGraph
  ttkMorseSmaleComplex
  ttkPathCompression
  ttkPeriodicGhostsGeneration
  ttkPersistenceCurve
  ttkPersistenceDiagram
  ttkPersistentGenerators
  ttkPlanarGraphLayout
  ttkReebSpace
  ttkRipsComplex
  ttkScalarFieldCriticalPoints
  ttkTopologicalSimplification
  ttkTopologicalSimplificationByPersistence
  ttkTrackingFromFields
  ttkTrackingFromOverlap
  ttkTrackingFromPersistenceDiagrams

  # geometry processing
  ttkBottleneckDistance
  ttkDepthImageBasedGeometryApproximation
  ttkDistanceField
  ttkGeometrySmoother
  ttkManifoldCheck
  ttkMarchingTetrahedra
  ttkMorseSmaleQuadrangulation
  ttkPointSetToCurve
  ttkPointSetToSurface
  ttkProjectionFromField
  ttkQuadrangulationSubdivision
  ttkSurfaceGeometrySmoother

  # clustering
  ttkLDistance
  ttkLDistanceMatrix
  ttkMatrixToHeatMap
  ttkMergeTreeClustering
  ttkMergeTreeDistanceMatrix
  ttkPersistenceDiagramClustering
  ttkPersistenceDiagramDistanceMatrix

  # ensemble
  ttkMandatoryCriticalPoints
  # ttkDimensionReduction # no sklearn available

  # compression
  ttkTopologicalCompressionReader
  ttkTopologicalCompressionWriter

  # cinema
  ttkCinemaReader
  ttkCinemaWriter
  ttkCinemaQuery
  ttkCinemaImaging
  ttkCinemaProductReader

  # darkroom
  ttkCinemaDarkroom
  ttkDarkroomCamera
  ttkDarkroomColorMapping
  ttkDarkroomCompositing
  ttkDarkroomFXAA
  ttkDarkroomIBS
  ttkDarkroomSSAO
  ttkDarkroomSSDoF
  ttkDarkroomSSSAO

  # table
  ttkDataSetToTable
  ttkMergeBlockTables
  ttkProjectionFromTable
  ttkTableDataSelector
  ttkTableDistanceMatrix

  # web scocket related, disabled because of missing dependency
  # ttkWebSocketIO
  # ttkWebSocketIO
)

if (eigen_enabled)
  list(APPEND ttk_enabled_modules
    ttkEigenField
    ttkHarmonicField
  )
endif()

# user defined modules
set(ttk_module_settings)
foreach (ttk_module IN LISTS ttk_enabled_modules ttk_CUSTOM_FILTERS)
  list(APPEND ttk_module_settings
    "-DVTK_MODULE_ENABLE_${ttk_module}:STRING=YES")
endforeach ()

# install location
if(UNIX)
  set(TTK_INSTALL_PLUGIN_DIR "lib/paraview-${paraview_version}/plugins/")
else()
  # windows
  set(TTK_INSTALL_PLUGIN_DIR "bin/paraview-${paraview_version}/plugins/")
endif()

# rpath location
set(ttk_rpath_config)
if (UNIX AND NOT APPLE)
   # we need CMAKE_INSTALL_RPATH to stay undefined on mac
   set(ttk_rpath_config "-DCMAKE_INSTALL_RPATH:STRING=$ORIGIN")
endif ()

# Build
# -----

# TODO: enable embree, for now
# there is a missing embree3/rtcore.h (windows)
superbuild_add_project(ttk
  DEPENDS paraview boost cxx11
  DEPENDS_OPTIONAL eigen numpy openmp python3 scipy zfp zlib
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    LicenseRef-BSD-TTK
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2017-2023, CNRS, Sorbonne Universite and contributors"
  SPDX_CUSTOM_LICENSE_FILE
    LICENSE
  SPDX_CUSTOM_LICENSE_NAME
    LicenseRef-BSD-TTK
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DTTK_BUILD_STANDALONE_APPS:BOOL=FALSE # trimmed folder
    -DCMAKE_INSTALL_LIBDIR:PATH=lib
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    ${ttk_rpath_config}
    -DTTK_INSTALL_PLUGIN_DIR:PATH=${TTK_INSTALL_PLUGIN_DIR}

    -DTTK_ENABLE_KAMIKAZE:BOOL=TRUE
    -DTTK_ENABLE_CPU_OPTIMIZATION:BOOL=FALSE
    -DTTK_ENABLE_DOUBLE_TEMPLATING:BOOL=OFF # save ressources for CI
    -DTTK_ENABLE_EIGEN:BOOL=${eigen_enabled}
    -DTTK_ENABLE_EMBREE:BOOL=NO
    -DTTK_ENABLE_GRAPHVIZ:BOOL=NO
    -DTTK_ENABLE_OPENMP:BOOL=${openmp_enabled}
    -DTTK_ENABLE_MPI:BOOL=NO
    -DTTK_ENABLE_SCIKIT_LEARN:BOOL=OFF
    -DTTK_ENABLE_ZFP:BOOL=${zfp_enabled}

    -DTTK_WHITELIST_MODE:BOOL=TRUE
    ${ttk_module_settings}
  )
