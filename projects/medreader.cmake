set(medreader_options)
if (UNIX AND NOT APPLE)
  set(medreader_rpath_entries
    <INSTALL_DIR>/lib)
  if (qt6_enabled)
    list(APPEND medreader_rpath_entries
      "${qt6_rpath}")
  endif ()
  list(JOIN medreader_rpath_entries "${_superbuild_list_separator}" medreader_rpath_entries)
  list(APPEND medreader_options
    -DCMAKE_INSTALL_RPATH:STRING=${medreader_rpath_entries})
endif ()

superbuild_add_project(medreader
  DEPENDS medfile medconfiguration medcoupling paraview
  DEPENDS_OPTIONAL mpi qt5 qt6
  LICENSE_FILES COPYING
  SPDX_LICENSE_IDENTIFIER
    LGPL-2.1-or-later
  SPDX_COPYRIGHT_TEXT
    # No copyright specified, extrapolated from some source files
    "Copyright (C) CEA/DEN, EDF R&D"
  SOURCE_SUBDIR src/Plugins/MEDReader
  CMAKE_ARGS
   -DCONFIGURATION_ROOT_DIR=<INSTALL_DIR>/configuration
   -DMEDCOUPLING_ROOT_DIR=<INSTALL_DIR>
   -DMEDREADER_USE_MPI:BOOL=${mpi_enabled}
   -DSALOME_USE_MPI:BOOL=${mpi_enabled}
   -DCMAKE_INSTALL_LIBDIR:PATH=lib
   -DBoost_USE_STATIC_LIBS:BOOL=OFF
   ${medreader_options}
)

superbuild_apply_patch(medreader install-medloaderforpv-in-correct-directory
  "Fix MEDLoaderForPV installation directory")

superbuild_apply_patch(medreader remove-custom-install
  "Remove custom installation")

superbuild_apply_patch(medreader add-missing-VTK-module-depends
  "Add a missing VTK module dependency")

superbuild_apply_patch(medreader quadrature-dataset
  "Update quadrature point generation")

superbuild_apply_patch(medreader fix-vtkStdString-usage
  "Fix vtkStdString usage")

superbuild_apply_patch(medreader pqTreeWidget-margins-api
  "Fix pqTreeWidget deprecated margin API usage")
