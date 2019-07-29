superbuild_add_project(adios2
  CAN_USE_SYSTEM
  DEPENDS_OPTIONAL
    bzip2 hdf5 mpi python zfp
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_TESTING:BOOL=OFF
    -DADIOS2_BUILD_EXAMPLES:BOOL=OFF
    -DADIOS2_USE_BZip2:STRING=${bzip2_enabled}
    -DADIOS2_USE_Blosc:STRING=OFF
    -DADIOS2_USE_DataMan:STRING=OFF
    -DADIOS2_USE_Fortran:STRING=OFF
    -DADIOS2_USE_HDF5:STRING=${hdf5_enabled}
    -DADIOS2_USE_MGARD:STRING=OFF
    -DADIOS2_USE_MPI:STRING=${mpi_enabled}
    -DADIOS2_USE_PNG:STRING=OFF
    -DADIOS2_USE_Profiling:STRING=OFF
    -DADIOS2_USE_Python:STRING=${python_enabled}
    -DADIOS2_USE_SSC:STRING=ON
    -DADIOS2_USE_SST:STRING=ON
    -DADIOS2_USE_SZ:STRING=OFF
    -DADIOS2_USE_ZFP:STRING=${zfp_enabled}
    -DADIOS2_USE_ZeroMQ:STRING=OFF)

superbuild_apply_patch(adios2 cmake-update-findmpi
  "Fix issues with FindMPI in downstream dependees")
