add_external_project(numpy
  DEPENDS python
  URL "http://fixme/numpy-1.6.1.tar.gz"
  URL_MD5 2bce18c08fc4fce461656f0f4dd9103e
  CONFIGURE_COMMAND "pwd"
  INSTALL_COMMAND "pwd"
  BUILD_IN_SOURCE 1
  BUILD_COMMAND
    <INSTALL_DIR>/bin/python setup.py install --prefix=<INSTALL_DIR>
)
