superbuild_add_project(medfile
  DEPENDS hdf5
  DEPENDS_OPTIONAL mpi
  LICENSE_FILES
    AUTHORS
    COPYING.LESSER
  SPDX_LICENSE_IDENTIFIER
    LGPL-3.0-or-later
  SPDX_COPYRIGHT_TEXT
    # No copyright specified, extrapolated from some source files
    "Copyright (C) CEA/DEN, EDF R&D, OPEN CASCADE"
  CMAKE_ARGS
   -DMEDFILE_INSTALL_DOC:BOOL=OFF
   -DMEDFILE_BUILD_TESTS:BOOL=OFF
   -DMEDFILE_USE_MPI:BOOL=${mpi_enabled}
)

superbuild_apply_patch(medfile remove-tools-compilation
  "Remove unneeded tools compilation")

superbuild_apply_patch(medfile fix-install-dirs
  "Fix install directories")

superbuild_apply_patch(medfile no-fortran
  "Disable CMake fortran logic")

superbuild_apply_patch(medfile hdf-1.14-compat
  "Support HDF5 1.14")
