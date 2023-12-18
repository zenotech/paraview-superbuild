set(medcoupling_options)
if (UNIX AND NOT APPLE)
  list(APPEND medcoupling_options
    -DCMAKE_INSTALL_RPATH:STRING=<INSTALL_DIR>/lib)
endif ()

superbuild_add_project(medcoupling
  DEPENDS medfile medconfiguration boost
  DEPENDS_OPTIONAL mpi
  LICENSE_FILES
    COPYING
  CMAKE_ARGS
   -DCONFIGURATION_ROOT_DIR=<INSTALL_DIR>/configuration
   -DBOOST_ROOT_DIR=<INSTALL_DIR>
   -DMEDCOUPLING_USE_MPI:BOOL=${mpi_enabled}
   -DMEDCOUPLING_ENABLE_PARTITIONER:BOOL=OFF
   -DMEDCOUPLING_ENABLE_PYTHON:BOOL=OFF
   -DMEDCOUPLING_BUILD_DOC:BOOL=OFF
   -DMEDCOUPLING_BUILD_TESTS:BOOL=OFF
   -DMEDCOUPLING_INSTALL_LIBS:PATH=lib
   -DSALOME_USE_MPI:BOOL=${mpi_enabled}
   -DMEDCOUPLING_MEDLOADER_USE_XDR:BOOL=OFF
   ${medcoupling_options}
)

superbuild_apply_patch(medcoupling fix-cmake-option-usage
  "Fix incorrect usage of cmake dependent option")

superbuild_apply_patch(medcoupling static-para-libs-windows-fix
  "Build para libs statically for Windows compatibility")

superbuild_apply_patch(medcoupling fix-install-directories
  "Fix install directories")
