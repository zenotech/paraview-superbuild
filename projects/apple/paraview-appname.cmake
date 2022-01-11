# Utility to determine ParaView app name
# Sets up a scoped variable named `paraview_appname`.
include(paraview-version)
set(name_suffix "")
if (paraview_version_branch)
  set(name_suffix "-${paraview_version_branch}")
endif ()
set(paraview_appname "ParaView${name_suffix}-${paraview_version_major}.${paraview_version_minor}.${paraview_version_patch}${paraview_version_suffix}.app")
