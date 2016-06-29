if(NOT python_version_minimum)
  set(python_version_minimum 2.6 CACHE INTERNAL "Minimum python version" FORCE)
endif()
find_package(PythonLibs   ${python_version_minimum} REQUIRED)
find_package(PythonInterp ${python_version_minimum}  REQUIRED)

# This will add PYTHON_LIBRARY, PYTHON_EXECUTABLE, PYTHON_INCLUDE_DIR
# variables. User can set/override these to change the Python being used.
add_extra_cmake_args(
  -DPYTHON_EXECUTABLE:FILEPATH=${PYTHON_EXECUTABLE}
  -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_DIR}
  -DPYTHON_LIBRARY:FILEPATH=${PYTHON_LIBRARY}
)
set (pv_python_executable "${PYTHON_EXECUTABLE}" CACHE INTERNAL "" FORCE)
