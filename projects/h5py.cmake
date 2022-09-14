set(h5py_environment)
if (mpi_enabled)
  list(APPEND h5py_environment
    HDF5_MPI ON)
  if (WIN32)
    list(APPEND h5py_environment
      H5PY_MSMPI ON)
  endif ()
endif ()

set(h5py_depends)
set(h5py_depends_optional)
if (mpi_enabled)
  list(APPEND h5py_depends
    pythonmpi4py)
else ()
  list(APPEND h5py_depends_optional
    pythonmpi4py)
endif ()

superbuild_add_project_python(h5py
  PACKAGE semantic_version
  DEPENDS hdf5 pythonsetuptools pythoncython numpy pythonpkgconfig ${h5py_depends}
  DEPENDS_OPTIONAL ${h5py_depends_optional} mpi
  LICENSE_FILES LICENSE
  PROCESS_ENVIRONMENT
    HDF5_DIR <INSTALL_DIR>
    ${h5py_environment})

superbuild_apply_patch(h5py minvers
  "Don't pin dependencies to exact versions during the build")

if (WIN32)
  # https://github.com/h5py/h5py/pull/2147
  superbuild_apply_patch(h5py msmpi-find
    "Support finding MSMPI")
endif ()
