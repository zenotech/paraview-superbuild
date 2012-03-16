add_external_project(numpy
  DEPENDS python
  CONFIGURE_COMMAND "pwd"
  INSTALL_COMMAND "pwd"
  BUILD_IN_SOURCE 1
  BUILD_COMMAND
    "${pv_python_executable} setup.py install --prefix=<INSTALL_DIR>"
)
