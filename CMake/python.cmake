# we support using system python.
dependent_option(USE_SYSTEM_PYTHON
  "Turn ON to use installed Python intead of building from source." OFF
  "ENABLE_PYTHON" OFF)

if (USE_SYSTEM_PYTHON)

  find_package(PythonLibs)
  find_package(PythonInterp)

  # This will add PYTHON_LIBRARY, PYTHON_EXECUTABLE, PYTHON_INCLUDE_DIR
  # variables. User can set/override these to change the Python being used.

  # this must be called since we're not using add_external_project().
  add_system_project(python)

  set (pv_python_executable "${PYTHON_EXECUTABLE}" CACHE INTERNAL "" FORCE)
else ()
  add_external_project(
    python
    DEPENDS zlib png
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
                      --prefix=<INSTALL_DIR>
                      --enable-unicode
                      --enable-shared
    )
  set (pv_python_executable "${install_location}/bin/python" CACHE INTERNAL "" FORCE)
endif()
