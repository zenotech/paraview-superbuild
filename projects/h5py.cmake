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

superbuild_add_project_python_pyproject(h5py
  PACKAGE h5py
  DEPENDS hdf5 pythonsetuptools pythoncython numpy pythonpkgconfig ${h5py_depends}
  DEPENDS_OPTIONAL ${h5py_depends_optional} mpi
  LICENSE_FILES LICENSE
  PROCESS_ENVIRONMENT
    HDF5_DIR <INSTALL_DIR>
    ${h5py_environment})

# https://github.com/h5py/h5py/pull/2306
superbuild_apply_patch(h5py noexcept-casts
  "Fix noexcept casting errors")
