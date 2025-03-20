if (BUILD_SHARED_LIBS)
  set(zeromq_shared -DBUILD_SHARED:BOOL=ON -DBUILD_STATIC:BOOL=OFF)
else()
  set(zeromq_shared -DBUILD_SHARED:BOOL=OFF -DBUILD_STATIC:BOOL=ON)
endif()

superbuild_add_project(zeromq
  LICENSE_FILES
    COPYING.LESSER
    AUTHORS
  SPDX_LICENSE_IDENTIFIER
    LGPL-3.0-linking-exception
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2007-2014 iMatix Corporation"
    "Copyright (c) 2009-2011 250bpm s.r.o."
    "Copyright (c) 2010-2011 Miru Limited"
    "Copyright (c) 2011 VMware, Inc."
    "Copyright (c) 2012 Spotify AB"
    "Copyright (c) 2013 Ericsson AB"
    "Copyright (c) 2014 AppDynamics Inc."
    "Copyright (c) 2015 Google, Inc."
    "Copyright (c) 2015-2016 Brocade Communications Systems Inc."
    "Copyright Individual zeromq Contributors"
  CMAKE_ARGS
    ${zeromq_shared}
    -DBUILD_TESTS:BOOL=OFF
    -DWITH_DOCS:BOOL=OFF
    -DZMQ_BUILD_TESTS:BOOL=OFF
    -DENABLE_PRECOMPILED:BOOL=OFF
  )

superbuild_add_extra_cmake_args(
  -DZeroMQ_DIR:PATH=<INSTALL_DIR>/CMake
  )
