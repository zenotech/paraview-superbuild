superbuild_add_project(gdal
  DEPENDS zlib
  DEPENDS_OPTIONAL cxx11
  LICENSE_FILES
    LICENSE.TXT
  CMAKE_ARGS
    -DGDAL_USE_CURL:BOOL=OFF
    -DGDAL_USE_LIBJPEG_INTERNAL:BOOL=ON
    -DGDAL_USE_LIBTIFF_INTERNAL:BOOL=ON
    -DGDAL_ENABLE_FRMT_PDF:BOOL=OFF
    -DGDAL_ENABLE_FRMT_VRT:BOOL=ON
    -DOGR_ENABLE_SHP:BOOL=ON
    -DGDAL_ENABLE_FRMT_MEM:BOOL=ON
    -DOGR_ENABLE_MEM:BOOL=ON)

superbuild_apply_patch(gdal no-sqlite
  "Disable sqlite support in GML")
superbuild_apply_patch(gdal lt_objdir-warning
  "Fix warning about LT_OBJDIR redefinition")
superbuild_apply_patch(gdal no-geos
  "Skip GEOS and Armadillo support")
superbuild_apply_patch(gdal pointer-comparison
  "Fix illegal pointer comparisons")
superbuild_apply_patch(gdal incdirs-fix
  "Remove unnecessary include directory")

if (APPLE)
  set(gdal_lib <INSTALL_DIR>/lib/libgdal111.dylib)
elseif (WIN32)
  set(gdal_lib <INSTALL_DIR>/lib/gdal111.lib)
else ()
  set(gdal_lib <INSTALL_DIR>/lib/libgdal111.so)
endif ()

superbuild_add_extra_cmake_args(
  -DGDAL_ROOT:PATH=<INSTALL_DIR>
  -DGDAL_INCLUDE_DIR:PATH=<INSTALL_DIR>/include/gdal
  -DGDAL_LIBRARY:FILEPATH=${gdal_lib})
