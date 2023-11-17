superbuild_add_project(eigen
  CAN_USE_SYSTEM
  DEPENDS boost
  LICENSE_FILES
     COPYING.README
     COPYING.LGPL # Technically, only section 3 of the LGPL applies to eigen as it is header only
     COPYING.MPL2
     COPYING.BSD
     COPYING.MINPACK
  SPDX_LICENSE_IDENTIFIER
    "MPL-2.0 BSD-3-Clause AND Minpack"
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2011, Intel Corporation"
    "Copyright Notice (1999) University of Chicago"
    "Copyright © 2008-2020 Benoît Jacob, Gaël Guennebaud and Eigen library contributors." # https://gitlab.com/libeigen/eigen/-/issues/2082
  CMAKE_ARGS
    -DCMAKE_CXX_FLAGS=-DEIGEN_MPL2_ONLY
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_TESTING:BOOL=OFF)
