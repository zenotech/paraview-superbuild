add_external_pv_plugin(pvospray
  PLUGIN_NAME pvOSPRay
  DEPENDS paraview ospray
)

## Patch to update pvospray to depend on correct rendering backend.
#add_external_project_step(patch_fix_install
#  COMMAND ${CMAKE_COMMAND} -E copy_if_different
#  ${SuperBuild_PROJECTS_DIR}/patches/pvospray.vtk.module.cmake
#  <SOURCE_DIR>/VTK/module.cmake
#  DEPENDEES update # do after update
#  DEPENDERS patch  # do before patch
#  )
