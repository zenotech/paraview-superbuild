set (_install_location "<INSTALL_DIR>")
if (WIN32)
  # numpy build has issues with paths containing "C:". So we set the prefix as a
  # relative path.
  set (_install_location "../../../install")
endif()

set(NUMPY_PROCESS_ENVIRONMENT)

# Set up the library path to make sure the right python libs get used
if(python_ENABLED AND NOT USE_SYSTEM_python)
  if(UNIX)
    list(APPEND NUMPY_PROCESS_ENVIRONMENT
      LD_LIBRARY_PATH "<INSTALL_DIR>/lib:$ENV{LD_LIBRARY_PATH}"
    )
  elseif(WIN32)
    list(APPEND NUMPY_PROCESS_ENVIRONMENT
      PATH "<INSTALL_DIR>/bin:$ENV{PATH}"
    )
  endif()
endif()

# Make sure that numpy uses the right BLAS and LAPACK
if(lapack_ENABLED)
  if(NOT LAPACK_FOUND)
    find_package(LAPACK REQUIRED)
  endif()
  list(APPEND NUMPY_PROCESS_ENVIRONMENT
    MKL "None"
    ATLAS "None"
    BLAS "${BLAS_LIBRARIES}"
    LAPACK "${LAPACK_LIBRARIES}"
  )
endif()

# If any variables are set, we must have the PROCESS_ENVIRONMENT keyword
if(NUMPY_PROCESS_ENVIRONMENT)
  set(NUMPY_PROCESS_ENVIRONMENT
     PROCESS_ENVIRONMENT ${NUMPY_PROCESS_ENVIRONMENT}
  )
endif()

add_external_project_or_use_system(numpy
  DEPENDS python
  CONFIGURE_COMMAND ""
  INSTALL_COMMAND
    ${pv_python_executable} setup.py install --prefix=${_install_location}
  BUILD_IN_SOURCE 1
  BUILD_COMMAND
    ${pv_python_executable} setup.py build --fcompiler=no
  ${NUMPY_PROCESS_ENVIRONMENT}
)
