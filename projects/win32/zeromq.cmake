
if (BUILD_SHARED_LIBS)
  set(zeromq_shared -DBUILD_SHARED:BOOL=ON -DBUILD_STATIC:BOOL=OFF)
else()
  set(zeromq_shared -DBUILD_SHARED:BOOL=OFF -DBUILD_STATIC:BOOL=ON)
endif()

superbuild_add_project(zeromq
  LICENSE_FILES
    COPYING.LESSER
  CMAKE_ARGS
    ${zeromq_shared}
    -DBUILD_TESTS:BOOL=OFF
    -DWITH_DOCS:BOOL=OFF
    -DZMQ_BUILD_TESTS:BOOL=OFF
  )

superbuild_add_extra_cmake_args(
  -DZeroMQ_DIR:PATH=<INSTALL_DIR>/CMake
  )
