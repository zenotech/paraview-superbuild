if (CMAKE_GENERATOR MATCHES "Ninja")
  set(meson_ninja_command "${CMAKE_MAKE_PROGRAM}")
else ()
  find_program(MESON_NINJA_COMMAND
    NAMES ninja-build ninja
    DOC "Path to `ninja` for meson projects")
  mark_as_advanced(MESON_NINJA_COMMAND)

  if (meson_enabled AND NOT MESON_NINJA_COMMAND)
    message(FATAL_ERROR
      "This build is using `meson` which requires a `ninja` binary to be "
      "present on the system when used. It has not been found (see "
      "`MESON_NINJA_COMMAND`). It is usually packaged as `ninja` or "
      "`ninja-build` in most package managers. It can also be downloaded "
      "from upstream directly: https://github.com/ninja-build/ninja/releases")
  endif ()
endif ()

superbuild_add_project_python(meson
  PACKAGE meson
  DEPENDS pythonsetuptools)
