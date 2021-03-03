set(pythonpkgconfig_depends)
if (UNIX)
  list(APPEND pythonpkgconfig_depends
    pkgconf)
endif ()

superbuild_add_project_python(pythonpkgconfig
  PACKAGE pkgconfig
  DEPENDS pythonsetuptools ${pythonpkgconfig_depends})
