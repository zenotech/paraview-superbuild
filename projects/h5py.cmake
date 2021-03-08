superbuild_add_project_python(h5py
  PACKAGE semantic_version
  DEPENDS hdf5 pythonsetuptools pythoncython numpy pythonpkgconfig
  DEPENDS_OPTIONAL pythonmpi4py
  PROCESS_ENVIRONMENT
    HDF5_DIR <INSTALL_DIR>)

superbuild_apply_patch(h5py minvers
  "Don't pin dependencies to exact versions during the build")
