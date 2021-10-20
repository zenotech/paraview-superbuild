set(las_configure_flags)
if (UNIX AND NOT APPLE)
  list(APPEND las_configure_flags
    -DCMAKE_INSTALL_RPATH:STRING=<INSTALL_DIR>/lib)
endif ()

superbuild_add_project(las
  DEPENDS boost
  CMAKE_ARGS
    -DWITH_GDAL:BOOL=FALSE
    -DBUILD_OSGEO4W:BOOL=OFF
    -DWITH_GEOTIFF:BOOL=FALSE
    -DWITH_LASZIP:BOOL=FALSE
    -DWITH_TESTS:BOOL=FALSE
    -DWITH_UTILITIES:BOOL=FALSE
    -DBoost_USE_STATIC_LIBS:BOOL=FALSE
    ${las_configure_flags})

# this patch is commited upstream at 4dbc30a7e7e099cbe01a7c192ec19d231cc26894
superbuild_apply_patch(las respect-with-geotiff
  "find_package GeoTIFF only if WITH_GEOTIFF")

superbuild_apply_patch(las enable-outside-boost-options
  "Enable outside boost options")

superbuild_apply_patch(las add-boost-include-dirs
  "Boost include dirs are needed on Windows")

superbuild_apply_patch(las allow-rpath
  "Don't reject RPATH settings on Linux")

superbuild_apply_patch(las new-boost
  "Support newer Boost versions")

if (WIN32)
  superbuild_append_flags(cxx_flags "-DBOOST_ALL_NO_LIB" PROJECT_ONLY)
endif()

if (APPLE)
  superbuild_append_flags(cxx_flags "-stdlib=libc++" PROJECT_ONLY)
  superbuild_append_flags(ld_flags "-stdlib=libc++" PROJECT_ONLY)
endif ()
