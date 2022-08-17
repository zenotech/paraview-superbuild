superbuild_add_project(eigen
  CAN_USE_SYSTEM
  DEPENDS boost
  LICENSE_FILES
     COPYING.README
     COPYING.LGPL # Technically, only section 3 of the LGPL applies to eigen as it is header only
     COPYING.MPL2
     COPYING.BSD
     COPYING.MINPACK
  CMAKE_ARGS
    -DCMAKE_CXX_FLAGS=-DEIGEN_MPL2_ONLY
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_TESTING:BOOL=OFF)
