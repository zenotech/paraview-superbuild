superbuild_add_project_python(meson
  PACKAGE meson
  DEPENDS pythonsetuptools ninja)

superbuild_apply_patch(meson armclang
  "add armclang support")
