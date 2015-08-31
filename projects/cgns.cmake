superbuild_add_project(cgns
  DEPENDS zlib hdf5

  CMAKE_ARGS
    -DCGNS_BUILD_SHARED:BOOL=${BUILD_SHARED_LIBS}
    -DENABLE_64BIT:BOOL=ON
    -DENABLE_HDF5:BOOL=ON
    -DHDF5_NEED_SZIP:BOOL=ON
    -DHDF5_NEED_ZLIB:BOOL=ON)

superbuild_apply_patch(cgns link-hdf5
  "Properly link to HDF5")
superbuild_apply_patch(cgns windows-install
  "Fix installation of libraries on Windows")
