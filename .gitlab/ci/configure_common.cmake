set(USE_NONFREE_COMPONENTS          ON CACHE BOOL "")
set(BUILD_TESTING                   ON CACHE BOOL "")

function (suppress_project name)
  set("SUPPRESS_${name}_OUTPUT" ON CACHE BOOL "")
endfunction ()

function (enable_project name)
  set("ENABLE_${name}" ON CACHE BOOL "")
  suppress_project("${name}")
endfunction ()

enable_project(adios2)
enable_project(blosc)
enable_project(cosmotools)
enable_project(ffmpeg)
enable_project(fortran)
enable_project(gdal)
enable_project(gmsh)
enable_project(h5py)
enable_project(launchers)
enable_project(matplotlib)
enable_project(mesa)
enable_project(mili)
enable_project(mpi)
enable_project(netcdf)
enable_project(nlohmannjson)
enable_project(numpy)
enable_project(nvidiaindex)
enable_project(openimagedenoise)
enable_project(openpmd)
enable_project(openvdb)
enable_project(ospray)
enable_project(ospraymaterials)
enable_project(ospraymodulempi)
enable_project(paraview)
enable_project(paraviewgettingstartedguide)
enable_project(paraviewpluginsexternal)
enable_project(paraviewtutorialdata)
enable_project(paraviewweb)
enable_project(python3)
enable_project(pythonpandas)
enable_project(pythonpygments)
enable_project(qt5)
enable_project(scipy)
enable_project(silo)
enable_project(surfacetrackercut)
enable_project(szip)
enable_project(tbb)
enable_project(ttk)
enable_project(visitbridge)
enable_project(vortexfinder2)
enable_project(vrpn)
enable_project(vtkm)
enable_project(xdmf3)
enable_project(zfp)

set(ENABLE_egl                      OFF CACHE BOOL "")
set(ENABLE_osmesa                   OFF CACHE BOOL "")
set(ENABLE_paraviewsdk              OFF CACHE BOOL "")
# needs cuda
set(ENABLE_visrtx                   OFF CACHE BOOL "")

# qt5 things
set(qt5_SOURCE_SELECTION            "5.15" CACHE STRING "")

# output suppressions
suppress_project(boost)
suppress_project(bzip2)
suppress_project(embree)
suppress_project(expat)
suppress_project(ffi)
suppress_project(fontconfig)
suppress_project(freetype)
suppress_project(genericio)
suppress_project(glproto)
suppress_project(gperf)
suppress_project(hdf5)
suppress_project(lapack)
suppress_project(libxml2)
suppress_project(llvm)
suppress_project(lookingglass)
suppress_project(mesa)
suppress_project(meson)
suppress_project(mili)
suppress_project(nvidiamdl)
suppress_project(nvidiaoptix)
suppress_project(openvkl)
suppress_project(osmesa)
suppress_project(paraviewwebdivvy)
suppress_project(paraviewwebglance)
suppress_project(paraviewweblite)
suppress_project(paraviewwebvisualizer)
suppress_project(pkgconf)
suppress_project(png)
suppress_project(pybind11)
suppress_project(pythonaiohttp)
suppress_project(pythonasynctimeout)
suppress_project(pythonattrs)
suppress_project(pythonbeniget)
suppress_project(pythoncffi)
suppress_project(pythonchardet)
suppress_project(pythoncppy)
suppress_project(pythoncycler)
suppress_project(pythoncython)
suppress_project(pythondateutil)
suppress_project(pythongast)
suppress_project(pythonidna)
suppress_project(pythonkiwisolver)
suppress_project(pythonmako)
suppress_project(pythonmultidict)
suppress_project(pythonpandas)
suppress_project(pythonpkgconfig)
suppress_project(pythonply)
suppress_project(pythonpycparser)
suppress_project(pythonpygments)
suppress_project(pythonpyparsing)
suppress_project(pythonpythran)
suppress_project(pythonsemanticversion)
suppress_project(pythonsetuptools)
suppress_project(pythonsetuptoolsrust)
suppress_project(pythonsetuptoolsscm)
suppress_project(pythonsix)
suppress_project(pythontoml)
suppress_project(pythontypingextensions)
suppress_project(pythonwheel)
suppress_project(pythonwslinkasync)
suppress_project(pythonyarl)
suppress_project(pytz)
suppress_project(rapidjson)
suppress_project(rkcommon)
suppress_project(snappy)
suppress_project(sqlite)
suppress_project(utillinux)
suppress_project(visrtx)
suppress_project(zlib)

if ("$ENV{CI_COMMIT_TITLE}" MATCHES "^paraview: add release v\(.*\)$")
  set(paraview_SOURCE_SELECTION           "${CMAKE_MATCH_1}" CACHE STRING "")
else ()
  set(paraview_SOURCE_SELECTION           "source" CACHE STRING "")
  file(TO_CMAKE_PATH "$ENV{CI_PROJECT_DIR}/source-paraview" paraview_source_dir)
  set(paraview_SOURCE_DIR                 "${paraview_source_dir}" CACHE PATH "")
endif ()

# Default to Release builds.
if ("$ENV{CMAKE_BUILD_TYPE}" STREQUAL "")
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
else ()
  set(CMAKE_BUILD_TYPE "$ENV{CMAKE_BUILD_TYPE}" CACHE STRING "")
endif ()

include("${CMAKE_CURRENT_LIST_DIR}/configure_sccache.cmake")
