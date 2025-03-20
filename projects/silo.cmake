superbuild_add_project(silo
  DEPENDS_OPTIONAL zlib szip hdf5
  LICENSE_FILES
    COPYRIGHT
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (C) 1994-2016 Lawrence Livermore National Security, LLC"
  CMAKE_ARGS
    -DCMAKE_INSTALL_NAME_DIR:STRING=<INSTALL_DIR>/lib

    -DSILO_ENABLE_SHARED:BOOL=${BUILD_SHARED_LIBS}
    -DSILO_ENABLE_BROWSER:BOOL=OFF
    -DSILO_ENABLE_FORTRAN:BOOL=OFF
    -DSILO_ENABLE_HDF5:BOOL=${hdf5_enabled}
    -DSILO_ENABLE_JSON:BOOL=OFF
    -DSILO_ENABLE_SILEX:BOOL=OFF
    -DSILO_ENABLE_PYTHON_MODULE:BOOL=OFF
    -DSILO_ENABLE_TESTS:BOOL=OFF
    -DSILO_BUILD_FOR_BSD_LICENSE:BOOL=ON

    # Set a site to avoid accidentally including any in-source site configs.
    -DSILO_CONFIG_SITE=STRING=paraview-superbuild)

# https://github.com/LLNL/Silo/pull/357
superbuild_apply_patch(silo version-file
  "Read the right file for the version number")

# https://github.com/LLNL/Silo/commit/39a533bbc9a221355698da88ac6d052a5217a148
superbuild_apply_patch(silo off64_t-size-detection
  "Fix off64_t size detection")

# https://github.com/LLNL/Silo/commit/18728aff1f640327c7a096e689e1f85f1e3895c4 (partial)
superbuild_apply_patch(silo no-force-install-prefix
  "Don't force the install prefix")

superbuild_apply_patch(silo no-perl
  "Remove perl requirement")
