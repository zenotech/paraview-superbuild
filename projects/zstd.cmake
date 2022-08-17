set(zstd_static_libs ON)
if (BUILD_SHARED_LIBS)
  set(zstd_static_libs OFF)
endif ()

superbuild_add_project(zstd
  CAN_USE_SYSTEM
  LICENSE_FILES
    LICENSE
  SOURCE_SUBDIR build/cmake
  CMAKE_ARGS
    -DBUILD_TESTING:BOOL=OFF
    -DZSTD_BUILD_SHARED:BOOL=${BUILD_SHARED_LIBS}
    -DZSTD_BUILD_STATIC:BOOL=${zstd_static_libs}
    -DZSTD_LEGACY_SUPPORT:BOOL=OFF
    -DZSTD_MULTITHREAD_SUPPORT:BOOL=ON
    -DZSTD_BUILD_PROGRAMS:BOOL=OFF
    -DZSTD_BUILD_CONTRIB:BOOL=OFF
    -DCMAKE_INSTALL_LIBDIR:PATH=lib)
