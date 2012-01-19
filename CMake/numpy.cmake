ExternalProject_Add(numpy
  PREFIX numpy
  DEPENDS python
  URL "http://fixme/numpy-1.6.1.tar.gz"
  URL_MD5 2bce18c08fc4fce461656f0f4dd9103e
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/downloads
  CONFIGURE_COMMAND ""
  BUILD_IN_SOURCE 1
  BUILD_COMMAND 
    ${CMAKE_COMMAND}
                     -DPREFIX:PATH=${internal_install_root}
                     -DSOURCE_DIR:PATH=<SOURCE_DIR>
                     -P ${CMAKE_CURRENT_SOURCE_DIR}/CMake/numpy.install 
  INSTALL_COMMAND ""
)
