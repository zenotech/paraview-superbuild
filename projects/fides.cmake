# Make a dummy fides project so that the user can enable or disable building
# paraview with fides support.
superbuild_add_dummy_project(fides
  DEPENDS adios2 vtkm)
