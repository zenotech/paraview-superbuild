superbuild_add_project(openpmd
  DEPENDS python3 nlohmannjson pybind11
  DEPENDS_OPTIONAL hdf5 adios2
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_LIBDIR:STRING=lib

    #openPMD MPI needs HDF5 to be built with MPI.
    -DopenPMD_USE_MPI:BOOL=OFF
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
