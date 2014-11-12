# INPUT VARIABLES:
# MATPLOTLIB_INSTALL_DIR
# MATPLOTLIB_SOURCE_DIR
# NUMPY_INSTALL_DIR
# PYTHON_EXECUTABLE
#    ${pv_python_executable} setup.py install --prefix=${_install_location}

# Find the location of numpy
file(GLOB_RECURSE numpy-egg "${NUMPY_INSTALL_DIR}/lib*/*.egg-info")
# message("${NUMPY_INSTALL_DIR}/lib/*.egg-info \n ${numpy-egg} --- ")
if (NOT numpy-egg)
  message(FATAL_ERROR "Failed to locate numpy-egg")
endif()

set (pythonpath $ENV{PYTHONPATH})
if (WIN32)
  set (separator ";")
else()
  set (separator ":")
endif()

set(ENV{PKG_CONFIG_PATH} "${MATPLOTLIB_INSTALL_DIR}/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}")

# since we may find multiple eggs (or may not), just loop over all of them.
foreach(egg ${numpy-egg})
  get_filename_component(dir "${egg}" PATH)
  if (pythonpath)
    set (pythonpath "${pythonpath}${separator}${dir}")
  else()
    set (pythonpath "${dir}")
  endif()
endforeach()
set (ENV{PYTHONPATH} "${pythonpath}")
message ("PYTHONPATH : ${pythonpath}")
execute_process(COMMAND ${PYTHON_EXECUTABLE} setup.py install --prefix=${MATPLOTLIB_INSTALL_DIR}
                WORKING_DIRECTORY ${MATPLOTLIB_SOURCE_DIR}
                RESULT_VARIABLE rv)
if (NOT "${rv}" STREQUAL "0")
  message(FATAL_ERROR "Failed to build matplot lib")
endif()
