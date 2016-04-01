message(STATUS "Using system EGL. Pick correct python based on your deployment target")
add_external_project_or_use_system(egl)
set(USE_SYSTEM_egl TRUE CACHE BOOL "" FORCE)
mark_as_advanced(USE_SYSTEM_egl)
