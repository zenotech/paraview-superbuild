function (adios_add_config_option adios_opt project include_dir)
  set(configure_option)
  if (USE_SYSTEM_${project})
    if (include_dir)
      list(GET include_dir 0 include_dir)
      get_filename_component(include_root "${include_dir}" DIRECTORY)
      set(configure_option "--with-${adios_opt}=${include_root}")
    else ()
      set(configure_option "--with-${adios_opt}")
    endif ()
  else ()
    set(configure_option "--with-${adios_opt}=<INSTALL_DIR>")
  endif ()

  set("${adios_opt}_option" ${configure_option} PARENT_SCOPE)
endfunction ()

set(adios_options)

adios_add_config_option(mxml mxml "${MXML_INCLUDE_DIR}")
list(APPEND adios_options ${mxml_option})
if (bzip2_enabled)
  adios_add_config_option(bzip2 bzip2 "${BZIP2_INCLUDE_DIR}")
  list(APPEND adios_options ${bzip2_option})
endif ()
if (zlib_enabled)
  adios_add_config_option(zlib zlib "${ZLIB_INCLUDE_DIR}")
  list(APPEND adios_options ${zlib_option})
endif ()
if (hdf5_enabled)
  adios_add_config_option(hdf5 hdf5 "${HDF5_INCLUDE_DIRS}")
  list(APPEND adios_options ${hdf5_option})
endif ()
if (netcdf_enabled)
  adios_add_config_option(netcdf netcdf "${NETCDF_INCLUDE_DIR}")
  list(APPEND adios_options ${netcdf_option})
endif ()

superbuild_add_project(adios
  CAN_USE_SYSTEM
  DEPENDS mpi mxml
  DEPENDS_OPTIONAL bzip2 zlib hdf5 netcdf
  BUILD_IN_SOURCE 1
  PATCH_COMMAND
    <SOURCE_DIR>/autogen.sh
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --with-lustre
      --disable-fortran
      ${adios_options}
  PROCESS_ENVIRONMENT
    CC     "${CMAKE_C_COMPILER}"
    CXX    "${CMAKE_CXX_COMPILER}"
    MPICC  "${MPI_C_COMPILER}"
    MPICXX "${MPI_CXX_COMPILER}")

superbuild_add_extra_cmake_args(
  -DADIOS_CONFIG:FILEPATH=<INSTALL_DIR>/bin/adios_config)
