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
  ttkMergeBlockTables
  ttkMergeTreeClustering
  ttkMergeTreeDistanceMatrix
  ttkMergeTreeTemporalReductionDecoding
  ttkMergeTreeTemporalReductionEncoding
  ttkMeshGraph
  ttkMorseSmaleComplex
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
  ttkMorseSmaleQuadrangulation
  ttkProjectionFromField
  ttkQuadrangulationSubdivision
  ttkSurfaceGeometrySmoother

  # clustering
  ttkPersistenceDiagramClustering

  # ensemble
  ttkMandatoryCriticalPoints
  ttkDimensionReduction

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
  ttkTableDataSelector
  ttkTableDistanceMatrix
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
# there is a missing embree3/rtcore.h
superbuild_add_project(ttk
  DEPENDS paraview boost cxx11
  DEPENDS_OPTIONAL eigen mpi numpy openmp python3 scipy zfp zlib
  LICENSE_FILES
    LICENSE
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DTTK_BUILD_STANDALONE_APPS:BOOL=FALSE
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
    # -DTTK_ENABLE_MPI:BOOL=${mpi_enabled} # temporary workaround
    -DTTK_ENABLE_MPI:BOOL=NO
    -DTTK_ENABLE_ZFP:BOOL=${zfp_enabled}

    -DTTK_WHITELIST_MODE:BOOL=TRUE
    ${ttk_module_settings}
  )
