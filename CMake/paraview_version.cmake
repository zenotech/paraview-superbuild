# We hardcode the version numbers since we cannot determine versions during
# configure stage.
set (pv_version_major 4)
set (pv_version_minor 1)
set (pv_version_patch 0)
set (pv_version_suffix "RC2")
set (pv_version "${pv_version_major}.${pv_version_minor}")
if (pv_version_suffix)
  set (pv_version_long "${pv_version}.${pv_version_patch}-${pv_version_suffix}")
else()
  set (pv_version_long "${pv_version}.${pv_version_patch}")
endif()
