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

  install(DIRECTORY "@install_location@/include"
          DESTINATION "include"
          COMPONENT superbuild)

  install(DIRECTORY "@install_location@/lib"
          DESTINATION "lib"
          COMPONENT superbuild
          PATTERN "paraview-${pv_version}" EXCLUDE)
endif()
