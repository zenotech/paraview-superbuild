macro(adios_add_config_option adios_opt cmake_opt cmake_inc cmake_lib)
  if(USE_SYSTEM_${cmake_opt})
    get_filename_component(TMP_DIR1 "${${cmake_inc}}" DIRECTORY)
    get_filename_component(TMP_DIR2 "${${cmake_lib}}" DIRECTORY)
    get_filename_component(TMP_DIR2 "${TMP_DIR2}" DIRECTORY)
    if(NOT (TMP_DIR1 STREQUAL TMP_DIR2))
      message(WARNING "Mismatched base dirs for ${adios_opt}. Using ${TMP_DIR1}")
    endif()
    list(APPEND adios_ARGS "--with-${adios_opt}=${TMP_DIR1}")
  else()
    list(APPEND adios_ARGS "--with-${adios_opt}=<INSTALL_DIR>")
  endif()
endmacro()

set(adios_DEPS)
set(adios_ARGS)
set(adios_ENV)

# ADIOS is *always* build statically so the best we can really do is make
# sure that it can be linked with shared libs
#if(BUILD_SHARED_LIBS)
#  set(adios_ENV CFLAGS "-fPIC" CXXFLAGS "-fPIC")
#endif()
#
# But as it turns out, the superbuild already does this for us
#

adios_add_config_option(mxml mxml MXML_INCLUDE_DIR MXML_LIBRARY)
if(ENABLE_bzip2)
  adios_add_config_option(bzip2 bzip2 BZIP2_INCLUDE_DIR BZIP2_LIBRARY)
  list(APPEND adios_DEPS bzip2)
endif()
if(ENABLE_zlib)
  adios_add_config_option(zlib zlib ZLIB_INCLUDE_DIR ZLIB_LIBRARY)
  list(APPEND adios_DEPS zlib)
endif()
if(ENABLE_hdf5)
  adios_add_config_option(hdf5 hdf5 HDF5_C_INCLUDE_DIR HDF5_hdf5_LIBRARY_RELEASE)
  list(APPEND adios_DEPS hdf5)
endif()
if(ENABLE_netcdf)
  adios_add_config_option(netcdf netcdf NETCDF_INCLUDE_DIR NETCDF_LIBRARY)
  list(APPEND adios_DEPS netcdf)
endif()

add_external_project_or_use_system(adios
  DEPENDS mpi mxml ${adios_DEPS}
  BUILD_IN_SOURCE 1
  PATCH_COMMAND     <SOURCE_DIR>/autogen.sh
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --with-lustre
                    --disable-fortran
                    ${adios_ARGS}
  PROCESS_ENVIRONMENT
    CC     "${CMAKE_C_COMPILER}"
    CXX    "${CMAKE_CXX_COMPILER}"
    MPICC  "${MPI_C_COMPILER}"
    MPICXX "${MPI_CXX_COMPILER}"
    ${adios_ENV}
)

add_extra_cmake_args(
  -DADIOS_CONFIG:FILEPATH=<INSTALL_DIR>/bin/adios_config
)
