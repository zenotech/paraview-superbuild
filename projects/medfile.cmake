set(medfile_options)
if (UNIX AND NOT APPLE)
  list(APPEND medfile_options
    -DCMAKE_INSTALL_RPATH:STRING=<INSTALL_DIR>/lib)
endif ()

superbuild_add_project(medfile
  DEPENDS hdf5
  DEPENDS_OPTIONAL mpi
  LICENSE_FILES
    AUTHORS
    COPYING.LESSER
  CMAKE_ARGS
   -DMEDFILE_INSTALL_DOC:BOOL=OFF
   -DMEDFILE_BUILD_TESTS:BOOL=OFF
   -DMEDFILE_USE_MPI:BOOL=${mpi_enabled}
   ${medfile_options}
)

superbuild_apply_patch(medfile remove-tools-compilation
  "Remove unneeded tools compilation")

superbuild_apply_patch(medfile fix-install-dirs
  "Fix install directories")

superbuild_apply_patch(medfile no-fortran
  "Disable CMake fortran logic")

superbuild_apply_patch(medfile hdf-1.14-compat
  "Support HDF5 1.14")
