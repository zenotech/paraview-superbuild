set(USE_NONFREE_COMPONENTS          ON CACHE BOOL "")
set(BUILD_TESTING                   ON CACHE BOOL "")

set(ENABLE_adios2                   ON CACHE BOOL "")
set(ENABLE_cosmotools               ON CACHE BOOL "")
set(ENABLE_egl                      OFF CACHE BOOL "")
set(ENABLE_ffmpeg                   ON CACHE BOOL "")
set(ENABLE_fortran                  ON CACHE BOOL "")
set(ENABLE_gdal                     ON CACHE BOOL "")
set(ENABLE_matplotlib               ON CACHE BOOL "")
set(ENABLE_mesa                     ON CACHE BOOL "")
set(ENABLE_mili                     ON CACHE BOOL "")
set(ENABLE_mpi                      ON CACHE BOOL "")
set(ENABLE_launchers                ON CACHE BOOL "")
set(ENABLE_netcdf                   ON CACHE BOOL "")
set(ENABLE_nlohmannjson             ON CACHE BOOL "")
set(ENABLE_numpy                    ON CACHE BOOL "")
set(ENABLE_nvidiaindex              ON CACHE BOOL "")
set(ENABLE_openimagedenoise         ON CACHE BOOL "")
set(ENABLE_osmesa                   OFF CACHE BOOL "")
set(ENABLE_ospraymaterials          ON CACHE BOOL "")
set(ENABLE_ospray                   ON CACHE BOOL "")
set(ENABLE_ospraymodulempi          ON CACHE BOOL "")
set(ENABLE_paraviewgettingstartedguide  ON CACHE BOOL "")
set(ENABLE_paraview                 ON CACHE BOOL "")
set(ENABLE_paraviewpluginsexternal  ON CACHE BOOL "")
set(ENABLE_paraviewsdk              OFF CACHE BOOL "")
set(ENABLE_paraviewtutorialdata     ON CACHE BOOL "")
set(ENABLE_paraviewweb              ON CACHE BOOL "")
set(ENABLE_python3                  ON CACHE BOOL "")
set(ENABLE_python                   ON CACHE BOOL "")
set(ENABLE_pythonpandas             ON CACHE BOOL "")
set(ENABLE_pythonpygments           ON CACHE BOOL "")
set(ENABLE_qt5                      ON CACHE BOOL "")
set(ENABLE_scipy                    ON CACHE BOOL "")
set(ENABLE_silo                     ON CACHE BOOL "")
set(ENABLE_szip                     ON CACHE BOOL "")
set(ENABLE_tbb                      ON CACHE BOOL "")
set(ENABLE_visitbridge              ON CACHE BOOL "")
# needs cuda
set(ENABLE_visrtx                   OFF CACHE BOOL "")
set(ENABLE_vortexfinder2            ON CACHE BOOL "")
set(ENABLE_vrpn                     ON CACHE BOOL "")
set(ENABLE_vtkm                     ON CACHE BOOL "")
set(ENABLE_xdmf3                    ON CACHE BOOL "")
set(ENABLE_zfp                      ON CACHE BOOL "")

# qt5 things
set(qt5_SOURCE_SELECTION            "5.10" CACHE STRING "")
# the gold linker seems to fail with internal error on centos7 builds
# disabling
set(qt5_EXTRA_CONFIGURATION_OPTIONS "-no-use-gold-linker" CACHE STRING "")

# output suppressions
set(SUPPRESS_boost_OUTPUT               ON CACHE BOOL "")
set(SUPPRESS_embree_OUTPUT              ON CACHE BOOL "")
set(SUPPRESS_ffmpeg_OUTPUT              ON CACHE BOOL "")
set(SUPPRESS_freetype_OUTPUT            ON CACHE BOOL "")
set(SUPPRESS_gdal_OUTPUT                ON CACHE BOOL "")
set(SUPPRESS_hdf5_OUTPUT                ON CACHE BOOL "")
set(SUPPRESS_lapack_OUTPUT              ON CACHE BOOL "")
set(SUPPRESS_mpi_OUTPUT                 ON CACHE BOOL "")
set(SUPPRESS_netcdf_OUTPUT              ON CACHE BOOL "")
set(SUPPRESS_numpy_OUTPUT               ON CACHE BOOL "")
set(SUPPRESS_openimagedenoise_OUTPUT    ON CACHE BOOL "")
set(SUPPRESS_openvkl_OUTPUT             ON CACHE BOOL "")
set(SUPPRESS_ospray_OUTPUT              ON CACHE BOOL "")
set(SUPPRESS_paraview_OUTPUT            ON CACHE BOOL "")
set(SUPPRESS_python3_OUTPUT             ON CACHE BOOL "")
set(SUPPRESS_pythonpandas_OUTPUT        ON CACHE BOOL "")
set(SUPPRESS_pythonzope_OUTPUT          ON CACHE BOOL "")
set(SUPPRESS_pythonzopeinterface_OUTPUT ON CACHE BOOL "")
set(SUPPRESS_qt5_OUTPUT                 ON CACHE BOOL "")
set(SUPPRESS_scipy_OUTPUT               ON CACHE BOOL "")
set(SUPPRESS_silo_OUTPUT                ON CACHE BOOL "")

set(paraview_SOURCE_SELECTION           "source" CACHE STRING "")
file(TO_CMAKE_PATH "$ENV{CI_PROJECT_DIR}/source-paraview" paraview_source_dir)
set(paraview_SOURCE_DIR                 "${paraview_source_dir}" CACHE PATH "")

# Default to Release builds.
if ("$ENV{CMAKE_BUILD_TYPE}" STREQUAL "")
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
else ()
  set(CMAKE_BUILD_TYPE "$ENV{CMAKE_BUILD_TYPE}" CACHE STRING "")
endif ()

include("${CMAKE_CURRENT_LIST_DIR}/configure_sccache.cmake")
