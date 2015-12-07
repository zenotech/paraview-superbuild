add_external_project_or_use_system(netcdf
  DEPENDS hdf5 zlib

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_TESTING:BOOL=FALSE
    -DBUILD_UTILITIES:BOOL=FALSE
    -DUSE_SZIP:BOOL=OFF
    -DENABLE_DAP:BOOL=OFF
)

#-------------------------------------------------------
# We've changed the API from upstream in VTK commits 6223f230 and
# 64cb89e3 to use size_t* instead of long* for (some) overloads of
# methods like NcVar::get. This patch adds a define to signal users
# that they should use size_t for these methods.
add_external_project_step(patch_netcdf_cxxheader
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          "${SuperBuild_PROJECTS_DIR}/patches/netcdf.cxx.netcdfcpp.h"
          "<SOURCE_DIR>/cxx/netcdfcpp.h"
DEPENDEES update # do after update
DEPENDERS patch  # do before patch
)
