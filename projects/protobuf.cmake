superbuild_add_project(protobuf
  LICENSE_FILES
    LICENSE
  DEPENDS cxx11
  DEPENDS_OPTIONAL zlib
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -Dprotobuf_BUILD_TESTS:BOOL=OFF)
