
if (hdf5_built_by_superbuild)
  if (szip_enabled)
    set(cgns_hdf5_szip -DHDF5_NEED_SZIP=ON)
  endif ()
  if (zlib_enabled)
    set(cgns_hdf5_zlib -DHDF5_NEED_ZLIB=ON)
  endif ()
endif ()
superbuild_add_project(cgns
  DEPENDS_OPTIONAL zlib szip hdf5
  CMAKE_ARGS
    -DCGNS_BUILD_SHARED:BOOL=${BUILD_SHARED_LIBS}
    -DCGNS_ENABLE_64BIT:BOOL=ON
    -DCGNS_ENABLE_HDF5:BOOL=${hdf5_enabled}
    ${cgns_hdf5_szip}
    ${cgns_hdf5_zlib})

superbuild_apply_patch(cgns windows-install
  "Fix installation of libraries on Windows")
superbuild_apply_patch(cgns hdf5-cmake
  "Fix HDF5 CMake usage")
