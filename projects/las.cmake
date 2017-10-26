set(las_cmake_args
  -DWITH_GDAL:BOOL=FALSE
  -DBUILD_OSGEO4W:BOOL=OFF
  -DWITH_GEOTIFF:BOOL=FALSE
  -DWITH_LASZIP:BOOL=FALSE
  -DWITH_TESTS:BOOL=FALSE
  -DWITH_UTILITIES:BOOL=FALSE)

# las sets, on windows, different boost options than the default
if(WIN32 AND MSVC)
  list(APPEND las_cmake_args -DBoost_USE_STATIC_LIBS:BOOL=FALSE)
endif()

superbuild_add_project(las
  DEPENDS boost
  CMAKE_ARGS
  ${las_cmake_args}
  )

# this patch is commited upstream at 4dbc30a7e7e099cbe01a7c192ec19d231cc26894
superbuild_apply_patch(las respect-with-geotiff
  "find_package GeoTIFF only if WITH_GEOTIFF")

superbuild_apply_patch(las enable-outside-boost-options
  "Enable outside boost options")

if (APPLE)
  superbuild_append_flags(cxx_flags "-stdlib=libc++" PROJECT_ONLY)
  superbuild_append_flags(ld_flags "-stdlib=libc++" PROJECT_ONLY)
endif ()
