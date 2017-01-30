set(cgns_need_szip OFF)
set(cgns_need_zlib OFF)
if (hdf5_built_by_superbuild)
  if (szip_enabled)
    set(cgns_need_szip ON)
  endif ()
  if (zlib_enabled)
    set(cgns_need_zlib ON)
  endif ()
endif ()

superbuild_add_project(cgns
  DEPENDS hdf5
  DEPENDS_OPTIONAL zlib szip
  CMAKE_ARGS
    -DCGNS_BUILD_SHARED:BOOL=${BUILD_SHARED_LIBS}
    -DCGNS_ENABLE_64BIT:BOOL=ON
    -DCGNS_ENABLE_HDF5:BOOL=${hdf5_enabled}
    -DHDF5_NEED_SZIP:BOOL=${cgns_need_szip}
    -DHDF5_NEED_ZLIB:BOOL=${cgns_need_zlib})

superbuild_apply_patch(cgns windows-install
  "Fix installation of libraries on Windows")
superbuild_apply_patch(cgns hdf5-cmake
  "Fix HDF5 CMake usage")
