find_program(MSBUILD_PATH NAMES msbuild)
mark_as_advanced(MSBUILD_PATH)

if (NOT MSBUILD_PATH)
  message(FATAL_ERROR "Unable to find msbuild; it is needed to build silo!")
endif ()

# 11.0 and below unsupported anyways.
if (NOT MSVC_VERSION VERSION_GREATER 1500)
  if (silo_enabled)
    message(FATAL_ERROR "At least Visual Studio 11.0 is required")
  endif ()
elseif (NOT MSVC_VERSION VERSION_GREATER 1700)
  set(silo_vs_version 11.0)
  set(silo_vs_toolset v110)
elseif (NOT MSVC_VERSION VERSION_GREATER 1800)
  set(silo_vs_version 12.0)
  set(silo_vs_toolset v120)
elseif (NOT MSVC_VERSION VERSION_GREATER 1900)
  set(silo_vs_version 14.0)
  set(silo_vs_toolset v140)
elseif (NOT MSVC_VERSION VERSION_GREATER 1910)
  set(silo_vs_version 15.0)
  set(silo_vs_toolset v141)
elseif (NOT MSVC_VERSION VERSION_GREATER 1930)
  set(silo_vs_version 15.0)
  set(silo_vs_toolset v142)
elseif (NOT MSVC_VERSION VERSION_GREATER 1932)
  set(silo_vs_version 15.0)
  set(silo_vs_toolset v143)
elseif (silo_enabled)
  message(FATAL_ERROR "Unrecognized MSVC version")
endif ()

set(silo_mpi_include_dirs)
if (mpi_enabled)
  list(JOIN MPI_C_INCLUDE_DIRS "${_superbuild_list_separator}" silo_mpi_include_dirs)
endif ()

superbuild_add_project(silo
  DEPENDS zlib hdf5
  DEPENDS_OPTIONAL mpi
  LICENSE_FILES
    COPYRIGHT
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    "${CMAKE_COMMAND}"
      -Dsource_location:PATH=<SOURCE_DIR>
      -Dinstall_location:PATH=<INSTALL_DIR>
      -P ${CMAKE_CURRENT_LIST_DIR}/scripts/silo.configure.cmake
  CONFIGURE_DEPENDS
    ${CMAKE_CURRENT_LIST_DIR}/scripts/silo.configure.cmake
  BUILD_COMMAND
    "${CMAKE_COMMAND}"
      -Dsource_location:PATH=<SOURCE_DIR>
      -Dinstall_location:PATH=<INSTALL_DIR>
      -DMSBUILD_PATH:FILEPATH=${MSBUILD_PATH}
      -Dvs_version:STRING=${silo_vs_version}
      -Dvs_toolset:STRING=${silo_vs_toolset}
      -Denable_mpi:BOOL=${mpi_enabled}
      -Dmpi_include_dirs:STRING=${silo_mpi_include_dirs}
      -Dmpi_library:STRING=${MPI_msmpi_LIBRARY}
      -P ${CMAKE_CURRENT_LIST_DIR}/scripts/silo.build.cmake
  BUILD_DEPENDS
    ${CMAKE_CURRENT_LIST_DIR}/scripts/silo.build.cmake
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dsource_location:PATH=<SOURCE_DIR>
      -Dinstall_location:PATH=<INSTALL_DIR>
      -P ${CMAKE_CURRENT_LIST_DIR}/scripts/silo.install.cmake
  INSTALL_DEPENDS
    ${CMAKE_CURRENT_LIST_DIR}/scripts/silo.install.cmake)

superbuild_apply_patch(silo no-perl
  "Remove the need for Perl during the build")
superbuild_apply_patch(silo hdf5-deplibs
  "Link to HDF5 properly")
superbuild_apply_patch(silo snprintf
  "Remove snprint redefinition for VS2015 and newer")
superbuild_apply_patch(silo hdf5-1.12
  "Support HDF5 1.12")
superbuild_apply_patch(silo hdf5-api-updates
  "Support HDF5 API updates")
# https://github.com/LLNL/Silo/commit/5dc160c7ae489b8181874dccf7ce3b8089c128f5.patch
superbuild_apply_patch(silo hdf5-1.13
  "Support HDF5 1.13")
superbuild_apply_patch(silo warning-preproc-mask
  "Hide `#warning` bits from MSVC")
superbuild_apply_patch(silo zfp-cond
  "zfp conditionals")
# https://github.com/LLNL/Silo/commit/3103c01189b76ea6406e5b964748b0ba7e5d4a08.patch
superbuild_apply_patch(silo hdf5-fields
  "HDF5 H5FD class fields")

superbuild_add_extra_cmake_args(
  -DSILO_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DSILO_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/silohdf5.lib)
