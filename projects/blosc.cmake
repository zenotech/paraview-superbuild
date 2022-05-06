set(blosc_static_libs ON)
if (BUILD_SHARED_LIBS)
  set(blosc_static_libs OFF)
endif ()

superbuild_add_project(blosc
  CAN_USE_SYSTEM
  DEPENDS
    zlib zstd
  LICENSE_FILES
    LICENSES/BLOSC.txt
    LICENSES/LZ4.txt
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DBUILD_SHARED:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_STATIC:BOOL=${blosc_static_libs}
    -DBUILD_TESTS:BOOL=OFF
    -DBUILD_FUZZERS:BOOL=OFF
    -DBUILD_BENCHMARKS:BOOL=OFF
    # good addition, but uses Makefiles: http://lz4.github.io/lz4/
    -DDEACTIVATE_LZ4:BOOL=OFF
    -DDEACTIVATE_SNAPPY:BOOL=ON
    -DDEACTIVATE_ZLIB:BOOL=ON
    -DDEACTIVATE_ZSTD:BOOL=ON
    -DPREFER_EXTERNAL_LZ4:BOOL=ON
    -DPREFER_EXTERNAL_ZLIB:BOOL=${zlib_enabled}
    -DPREFER_EXTERNAL_ZSTD:BOOL=${zstd_enabled})
