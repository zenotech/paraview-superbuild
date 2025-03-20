set(blosc2_static_libs ON)
if (BUILD_SHARED_LIBS)
  set(blosc2_static_libs OFF)
endif ()

superbuild_add_project(blosc2
  CAN_USE_SYSTEM
  DEPENDS
    zlib lz4
  LICENSE_FILES
    LICENSE.txt
  SPDX_LICENSE_IDENTIFIER
    "BSD-3-Clause AND BSD-2-Clause"
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2009-2018 Francesc Alted <francesc@blosc.org>"
    "Copyright (c) 2019-present The Blosc Development Team <blosc@blosc.org>"
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DBUILD_SHARED:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_STATIC:BOOL=${blosc2_static_libs}
    -DBUILD_BENCHMARKS:BOOL=OFF
    -DBUILD_EXAMPLES:BOOL=OFF
    -DBUILD_FUZZERS:BOOL=OFF
    -DBUILD_TESTS:BOOL=OFF
    -DDEACTIVATE_IPP:BOOL=ON
    -DDEACTIVATE_SNAPPY:BOOL=ON
    -DDEACTIVATE_ZSTD:BOOL=ON
    -DPREFER_EXTERNAL_LZ4:BOOL=${lz4_enabled}
    -DPREFER_EXTERNAL_ZLIB:BOOL=${zlib_enabled})
