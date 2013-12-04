add_external_dummy_project(paraviewsdk DEPENDS paraview)
if (paraviewsdk_ENABLED)
  if (qt_ENABLED AND NOT USE_SYSTEM_qt)
    message(WARNING "Please use System-Qt or disable Qt to enable SDK deployment")
    return()
  endif()

  if (python_ENABLED AND NOT USE_SYSTEM_python)
    message(WARNING "Please use System-Python or disable Python to enable SDK deployment")
    return()
  endif()

  if (mpi_ENABLED AND NOT USE_SYSTEM_mpi)
    message(WARNING "Please use System-MPI or disable MPI to enable SDK deployment")
    return()
  endif()

  # install all include files.
  install(DIRECTORY "@install_location@/include/"
          DESTINATION "include"
          COMPONENT superbuild)

  # install all library files (including those for dependencies built).
  install(DIRECTORY "@install_location@/lib/"
          DESTINATION "lib"
          COMPONENT superbuild
          PATTERN "paraview-${pv_version}" EXCLUDE)

  # install all CMake files.
  install(DIRECTORY "@install_location@/lib/cmake/"
          DESTINATION "lib/cmake"
          COMPONENT superbuild)

  # install all executables since these include the wrapping tools and others.
  install(DIRECTORY "@install_location@/bin/"
          DESTINATION "bin"
          USE_SOURCE_PERMISSIONS
          COMPONENT superbuild)
endif()
