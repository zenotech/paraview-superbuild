ExternalProject_Add(
  hdf5
  PREFIX hdf5
  DEPENDS zlib szip
  URL "http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.8.tar.gz"
  URL_MD5 1196e668f5592bfb50d1de162eb16cff
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/downloads
  CMAKE_ARGS
    -DCMAKE_PREFIX_PATH:PATH=${internal_install_root}
    -DCMAKE_INSTALL_PREFIX:PATH=${internal_install_root}
    -DBUILD_SHARED_LIBS:BOOL=TRUE
    -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=TRUE
    -DHDF5_ENABLE_SZIP_SUPPORT:BOOL=TRUE
    -DHDF5_ENABLE_SZIP_ENCODING:BOOL=TRUE
    -DSZIP_LIBRARY:FILEPATH=${internal_install_root}/lib/libsz.so
    -DSZIP_INCLUDE_DIR:FILEPATH=${internal_install_root}/include
)
