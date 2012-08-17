add_external_project(
  cgns
  DEPENDS zlib hdf5
  CMAKE_ARGS
  -DCGNS_BUILD_SHARED:BOOL=ON
  -DENABLE_64BIT:BOOL=ON
# we didn't enable hdf5 support in past,
# and even now, we seem to have build issues,
# so disabling it.
  -DENABLE_HDF5:BOOL=OFF
#  -DENABLE_HDF5:BOOL=ON
#  -DHDF5_NEED_SZIP:BOOL=ON
#  -DHDF5_NEED_ZLIB:BOOL=ON
)
