if (BUILD_SHARED_LIBS)
  set(genericio_lib_suffix ${CMAKE_SHARED_LIBRARY_SUFFIX})
else ()
  set(genericio_lib_suffix ${CMAKE_STATIC_LIBRARY_SUFFIX})
endif ()

superbuild_add_project(genericio
  DEPENDS mpi
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_TESTING:BOOL=OFF
    -DBUILD_PROGRAMS:BOOL=OFF
  INSTALL_COMMAND
    ${CMAKE_COMMAND} -E copy
      <BINARY_DIR>/libGenericIO${lib_suffix}
      <INSTALL_DIR>/lib)

superbuild_add_extra_cmake_args(

if (TARGET genericio)
  set(genericio_include_dir "<SOURCE_DIR>")
  _ep_replace_location_tags(genericio genericio_include_dir)

  superbuild_add_extra_cmake_args(
    -DGENERIC_IO_INCLUDE_DIR:PATH=${genericio_include_dir}
    -DGENERIC_IO_LIBRARIES:PATH=<INSTALL_DIR>/libGenericIO${lib_suffix})
endif ()
