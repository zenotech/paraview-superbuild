superbuild_add_project(eigen
  CAN_USE_SYSTEM
  DEPENDS boost
  LICENSE_FILES
     COPYING.README
     COPYING.MPL2
     COPYING.BSD
  SPDX_LICENSE_IDENTIFIER
    "MPL-2.0 AND BSD-3-Clause"
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2011, Intel Corporation"
    "Copyright © 2008-2020 Benoît Jacob, Gaël Guennebaud and Eigen library contributors." # https://gitlab.com/libeigen/eigen/-/issues/2082
  CMAKE_ARGS
    -DCMAKE_CXX_FLAGS=-DEIGEN_MPL2_ONLY
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_TESTING:BOOL=OFF)
