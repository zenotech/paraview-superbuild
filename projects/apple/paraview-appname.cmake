# Utility to determine ParaView app name
# Sets up a scoped variable named `paraview_appname`.
include(paraview-version)
set(paraview_appname "ParaView-${paraview_version_major}.${paraview_version_minor}.${paraview_version_patch}${paraview_version_suffix}.app")
