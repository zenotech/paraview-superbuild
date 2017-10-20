superbuild_add_project(las
  DEPENDS boost
  CMAKE_ARGS
    -DWITH_GDAL:BOOL=FALSE
    -DWITH_GEOTIFF:BOOL=FALSE
    -DWITH_LASZIP:BOOL=FALSE
    -DWITH_TESTS:BOOL=FALSE
    -DWITH_UTILITIES:BOOL=FALSE)

superbuild_apply_patch(las respect-with-geotiff
  "find_package GeoTIFF only if WITH_GEOTIFF")
