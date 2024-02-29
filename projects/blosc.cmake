set(blosc_configure_flags)
if (UNIX AND NOT APPLE)
  list(APPEND blosc_configure_flags
    -DCMAKE_INSTALL_RPATH:STRING=<INSTALL_DIR>/lib)
endif ()

set(blosc_static_libs ON)
if (BUILD_SHARED_LIBS)
  set(blosc_static_libs OFF)
endif ()

set(blosc_disable_snappy ON)
if (snappy_enabled)
  set(blosc_disable_snappy OFF)
endif ()

superbuild_add_project(blosc
  CAN_USE_SYSTEM
  DEPENDS
    zlib zstd lz4
  DEPENDS_OPTIONAL
    snappy
  LICENSE_FILES
    LICENSE.txt
  SPDX_LICENSE_IDENTIFIER
    "BSD-3-Clause AND BSD-2-Clause"
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2009-2018 Francesc Alted"
    "Copyright (c) 2019-present Blosc Development Team"
  CMAKE_ARGS
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    ${blosc_configure_flags}
    # Prevent installation of system libraries; the superbuild handles this.
    -DBLOSC_IS_SUBPROJECT:BOOL=TRUE
    # Force installation on; as a subproject, blosc disables installation by
    # default.
    -DBLOSC_INSTALL:BOOL=TRUE
    -DBUILD_SHARED:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_STATIC:BOOL=${blosc_static_libs}
    -DBUILD_TESTS:BOOL=OFF
    -DBUILD_FUZZERS:BOOL=OFF
    -DBUILD_BENCHMARKS:BOOL=OFF
    -DDEACTIVATE_LZ4:BOOL=OFF
    -DDEACTIVATE_SNAPPY:BOOL=${blosc_disable_snappy}
    -DDEACTIVATE_ZLIB:BOOL=OFF
    -DDEACTIVATE_ZSTD:BOOL=OFF
    -DPREFER_EXTERNAL_LZ4:BOOL=${lz4_enabled}
    -DPREFER_EXTERNAL_ZLIB:BOOL=${zlib_enabled}
    -DPREFER_EXTERNAL_ZSTD:BOOL=${zstd_enabled})
