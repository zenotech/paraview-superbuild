
ExternalProject_Add(
  png
  DEPENDS zlib
  PREFIX png
  URL "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng-1.4.8.tar.gz"
  URL_MD5 49c6e05be5fa88ed815945d7ca7d4aa9

# Can't use 1.5 since Qt 4.6.* is making use of deprecated API.
#  URL "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng-1.5.7.tar.gz"
#  URL_MD5 944b56a84b65d94054cc73d7ff965de8
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/downloads
  CMAKE_ARGS
    -DCMAKE_INSTALL_PREFIX:PATH=${internal_install_root}
    -DPNG_TESTS:BOOL=OFF
    -DCMAKE_PREFIX_PATH:PATH=${internal_install_root}
  )
