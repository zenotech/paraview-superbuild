set(pythonpkgconfig_depends)
if (UNIX)
  list(APPEND pythonpkgconfig_depends
    pkgconf)
endif ()

superbuild_add_project_python(pythonpkgconfig
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2013 Matthias Vogelgesang"
  PACKAGE pkgconfig
  DEPENDS pythonsetuptools ${pythonpkgconfig_depends})
