superbuild_add_project(openpmd
  DEPENDS python3 nlohmannjson pybind11
  DEPENDS_OPTIONAL hdf5 adios2 mpi
  LICENSE_FILES
    COPYING
    COPYING.LESSER
    share/openPMD/thirdParty/json/LICENSE.MIT
    share/openPMD/thirdParty/pybind11/LICENSE
  SPDX_LICENSE_IDENTIFIER
    "LGPL-3.0-or-later AND MIT AND BSD-3-Clause"
  SPDX_COPYRIGHT_TEXT
    "Copyright Axel Huebl, Franz Poeschel, Fabian Koller, Junmin Gu" # From PKG-INFO
    "Copyright (c) 2013-2020 Niels Lohmann" # json
    "Copyright (c) 2016 Wenzel Jakob" # pybind11
  CMAKE_ARGS
    -DCMAKE_INSTALL_LIBDIR:STRING=lib

    -DopenPMD_USE_MPI:BOOL=${mpi_enabled}
    -DopenPMD_USE_HDF5:BOOL=${hdf5_enabled}
    -DopenPMD_USE_ADIOS2:BOOL=${adios2_enabled}
    -DopenPMD_USE_ADIOS1:BOOL=OFF
    -DopenPMD_USE_PYTHON:BOOL=ON
    -DopenPMD_USE_INTERNAL_PYBIND11:BOOL=OFF
    -DopenPMD_USE_INTERNAL_VARIANT:BOOL=ON
    -DopenPMD_USE_INTERNAL_CATCH:BOOL=ON
    -DopenPMD_USE_INTERNAL_JSON:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    -DBUILD_EXAMPLES:BOOL=OFF
    -DBUILD_CLI_TOOLS:BOOL=OFF

    # this is necessary to add rpaths to installed libopenpmd_api
    # so that libopenPMD can be found correctly at runtime.
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=TRUE
    )

# For some reason, CMake 3.19 cannot find `Development.Module` without
# `Development` also being specified. The version number doesn't seem to get
# extracted which trips up later version checks.
superbuild_apply_patch(openpmd find-python-components
  "request the full Development Python component")
