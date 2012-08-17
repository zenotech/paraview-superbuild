message(STATUS "Using system python")
add_external_project_or_use_system(python)
set(USE_SYSTEM_python TRUE CACHE BOOL "" FORCE)

# such an option is not provided for apple or unix.
option(PACKAGE_PYTHON_WITH_APPLICATION "Enable to include python in application bundle" ON)
