cmake_dependent_option(adios2_USE_FABRIC
  "Enable the use of RDMA fabrics for the SST engine" OFF
  "CMAKE_SYSTEM_NAME MATCHES Linux" OFF)
mark_as_advanced(adios2_USE_FABRIC)

set(adios2_extra_deps)
if(adios2_USE_FABRIC)
  list(APPEND adios2_extra_deps libfabric)
else()
  list(APPEND adios2_extra_args -DPC_LIBFABRIC_FOUND:STRING=IGNORE)
endif()

if(UNIX)
  list(APPEND adios2_extra_deps ffi)
endif()

superbuild_add_project(adios2
  CAN_USE_SYSTEM
  DEPENDS
    cxx11 zfp ${adios2_extra_deps}
  DEPENDS_OPTIONAL
    mpi
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_TESTING:BOOL=OFF
    -DADIOS2_BUILD_EXAMPLES:BOOL=OFF
    -DADIOS2_USE_BZip2:STRING=OFF
    -DADIOS2_USE_Blosc:STRING=OFF
    -DADIOS2_USE_DataMan:STRING=OFF
    -DADIOS2_USE_Fortran:STRING=OFF
    -DADIOS2_USE_HDF5:STRING=OFF
    -DADIOS2_USE_MGARD:STRING=OFF
    -DADIOS2_USE_MPI:STRING=${mpi_enabled}
    -DADIOS2_USE_PNG:STRING=OFF
    -DADIOS2_USE_Profiling:STRING=OFF
    -DADIOS2_USE_Python:STRING=OFF
    -DADIOS2_USE_SSC:STRING=ON
    -DADIOS2_USE_SST:STRING=ON
    -DADIOS2_USE_SZ:STRING=OFF
    -DADIOS2_USE_ZFP:STRING=${zfp_enabled}
    -DADIOS2_USE_ZeroMQ:STRING=OFF
    -DEVPATH_TRANSPORT_MODULES:BOOL=OFF
    ${adios2_extra_args})

if(adios2_SOURCE_SELECTION STREQUAL "v2.4.0")
  superbuild_apply_patch(adios2 cmake-update-findmpi
    "Fix issues with FindMPI in downstream dependees")
endif()
