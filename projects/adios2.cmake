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
    cxx11 ${adios2_extra_deps}
    # currently adios 2.6 unconditionally needs Python
    # even if Python wrapping is disabled.
    python3
  DEPENDS_OPTIONAL
    mpi blosc zfp png
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_TESTING:BOOL=OFF
    -DADIOS2_BUILD_EXAMPLES:BOOL=OFF
    -DADIOS2_USE_BZip2:STRING=OFF
    # Compilation errors with the `blosc` in the superbuild. Needs
    # investigation.
    # https://gitlab.kitware.com/paraview/paraview-superbuild/-/issues/195
    #-DADIOS2_USE_Blosc:STRING=${blosc_enabled}
    -DADIOS2_USE_Blosc:STRING=OFF
    -DADIOS2_USE_DataMan:STRING=OFF
    -DADIOS2_USE_Fortran:STRING=OFF
    -DADIOS2_USE_HDF5:STRING=OFF
    -DADIOS2_USE_MGARD:STRING=OFF
    -DADIOS2_USE_MPI:STRING=${mpi_enabled}
    -DADIOS2_USE_PNG:STRING=${png_enabled}
    -DADIOS2_USE_Profiling:STRING=OFF
    -DADIOS2_USE_Python:STRING=OFF
    -DADIOS2_USE_SSC:STRING=ON
    -DADIOS2_USE_SST:STRING=ON
    -DADIOS2_USE_SZ:STRING=OFF
    -DADIOS2_USE_ZFP:STRING=${zfp_enabled}
    -DADIOS2_USE_ZeroMQ:STRING=OFF
    -DEVPATH_TRANSPORT_MODULES:BOOL=OFF
    ${adios2_extra_args})
