
# zlib supports cmake. the only problem is that we need to remove the zconf.h
# file.
ExternalProject_Add(
  zlib
  PREFIX zlib
  URL "http://zlib.net/zlib-1.2.5.tar.gz"
  URL_MD5 c735eab2d659a96e5a594c9e8541ad63
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/downloads
  # remove the zconf.h as a patch step.
  PATCH_COMMAND cmake -E remove -f <SOURCE_DIR>/zconf.h
  CMAKE_ARGS
    -DCMAKE_INSTALL_PREFIX:PATH=${internal_install_root}
    -DCMAKE_PREFIX_PATH=${internal_install_root}
  )
