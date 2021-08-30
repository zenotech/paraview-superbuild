if (NOT CMAKE_GENERATOR MATCHES "Ninja"
    AND meson_enabled)
  message(WARNING
    "This build is using `meson` which requires a `ninja` binary to be "
    "present on the system when used. Since this build is not using the Ninja "
    "generator, you may be missing this tool. It is usually packaged as "
    "`ninja` or `ninja-build` in most package managers. It can also be "
    "downloaded from upstream directly: "
    "https://github.com/ninja-build/ninja/releases")
endif ()

superbuild_add_project_python(meson
  PACKAGE meson
  DEPENDS pythonsetuptools)
