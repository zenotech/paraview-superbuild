set(pythonpath "$ENV{PYTHONPATH}")
if (WIN32)
  set(separator ";")
else ()
  set(separator ":")
endif ()

set(ENV{PKG_CONFIG_PATH} "${install_location}/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}")

file(TO_NATIVE_PATH "${install_location}" install_location)

execute_process(
  COMMAND "${PYTHON_EXECUTABLE}"
          setup.py
          install
          "--prefix=${install_location}"
  RESULT_VARIABLE   rv
  WORKING_DIRECTORY ${source_location})
if (rv)
  message(FATAL_ERROR "Failed to build matplotlib")
endif ()
