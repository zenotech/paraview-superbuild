
# zlib supports cmake. the only problem is that we need to remove the zconf.h
# file.
add_external_project(
  zlib
  URL "http://zlib.net/zlib-1.2.5.tar.gz"
  URL_MD5 c735eab2d659a96e5a594c9e8541ad63
  # remove the zconf.h as a patch step.
  PATCH_COMMAND ${CMAKE_COMMAND} -E remove -f <SOURCE_DIR>/zconf.h
  )
