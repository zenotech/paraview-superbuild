add_external_project(
  silo
  DEPENDS zlib hdf5
  BUILD_IN_SOURCE 1
  PATCH_COMMAND 
    ${CMAKE_COMMAND} -DSILO_PATCHES_DIR:PATH=${ParaViewSuperBuild_PROJECTS_DIR}/patches/silo_win32
                     -D64BIT_BUILD:BOOL=${64bit_build}
                     -DSILO_SOURCE_DIR:PATH=<SOURCE_DIR>
                     -DSILO_INSTALL_DIR:PATH=<INSTALL_DIR>
                     -P ${CMAKE_CURRENT_LIST_DIR}/silo.patch.cmake
  CONFIGURE_COMMAND
    ${CMAKE_COMMAND} -DSILO_PATCHES_DIR:PATH=${ParaViewSuperBuild_PROJECTS_DIR}/patches/silo_win32
                     -D64BIT_BUILD:BOOL=${64bit_build}
                     -DSILO_SOURCE_DIR:PATH=<SOURCE_DIR>
                     -DSILO_INSTALL_DIR:PATH=<INSTALL_DIR>
                     -P ${CMAKE_CURRENT_LIST_DIR}/silo.configure.cmake
  BUILD_COMMAND
    ${CMAKE_COMMAND} -DSILO_PATCHES_DIR:PATH=${ParaViewSuperBuild_PROJECTS_DIR}/patches/silo_win32
                     -D64BIT_BUILD:BOOL=${64bit_build}
                     -DSILO_SOURCE_DIR:PATH=<SOURCE_DIR>
                     -DSILO_INSTALL_DIR:PATH=<INSTALL_DIR>
                     -DDEVENV_PATH:FILEPATH=${DEVENV_PATH}
                     -P ${CMAKE_CURRENT_LIST_DIR}/silo.build.cmake
  INSTALL_COMMAND
    ${CMAKE_COMMAND} -DSILO_PATCHES_DIR:PATH=${ParaViewSuperBuild_PROJECTS_DIR}/patches/silo_win32
                     -D64BIT_BUILD:BOOL=${64bit_build}
                     -DSILO_SOURCE_DIR:PATH=<SOURCE_DIR>
                     -DSILO_INSTALL_DIR:PATH=<INSTALL_DIR>
                     -P ${CMAKE_CURRENT_LIST_DIR}/silo.install.cmake
)

add_extra_cmake_args(
  -DSILO_INCLUDE_DIR:PATH=${install_location}/include
  -DSILO_LIBRARY:FILEPATH=${install_location}/lib/silohdf5.lib)
