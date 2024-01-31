superbuild_add_project(protobuf
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright 2008 Google Inc."
  DEPENDS cxx11 abseil
  DEPENDS_OPTIONAL zlib
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -Dprotobuf_ABSL_PROVIDER:STRING=package
    -Dprotobuf_BUILD_TESTS:BOOL=OFF)
