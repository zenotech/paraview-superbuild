set (configuration)
set (python_executable_dir)
if (64bit_build)
  set (configuration "Release|x64")
  set (python_executable_dir
    "${ParaViewSuperBuild_BINARY_DIR}/python/src/python/PCbuild/amd64")
else()
  set (configuration "Release|Win32")
  set (python_executable_dir
    "${ParaViewSuperBuild_BINARY_DIR}/python/src/python/PCbuild")
endif()


#------------------------------------------------------------------------------
add_external_project_or_use_system(python
  DEPENDS zlib
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND "echo"
  BUILD_COMMAND ${CMAKE_BUILD_TOOL} PCbuild/pcbuild.sln /build ${configuration}
                                    /project python
  #devenv doesn't seem to building all specified projects when I list them in
  #same command line. So making them separate calls.
  INSTALL_COMMAND "echo"
)

#------------------------------------------------------------------------------
set (python_projects_to_build
  select
  make_versioninfo
  make_buildinfo
  kill_python
  w9xpopen
  pythoncore
  _socket
  _testcapi
  _msi
  _elementtree
  _ctypes_test
  _ctypes
  winsound
  pyexpat
  _multiprocessing
  pythonw)

foreach(dep IN LISTS python_projects_to_build)
  add_external_project_step(python-project-${dep}
    COMMAND ${CMAKE_BUILD_TOOL} <SOURCE_DIR>/PCbuild/pcbuild.sln /build ${configuration}
                                /project ${dep}
    DEPENDEES build
    DEPENDERS install)
endforeach()

#------------------------------------------------------------------------------
set (pv_python_executable "${python_executable_dir}/python.exe")
add_extra_cmake_args(
  -DPYTHON_EXECUTABLE:FILEPATH=${python_executable_dir}/python.exe
  -DPYTHON_INCLUDE_DIR:FILEPATH=${ParaViewSuperBuild_BINARY_DIR}/python/src/python/Include
  -DPYTHON_LIBRARY:FILEPATH=${python_executable_dir}/python27.lib)
