set(jsonc_static ON)
if (BUILD_SHARED_LIBS)
  set(jsonc_static OFF)
endif ()

superbuild_add_project(jsonc
  LICENSE_FILES
    COPYING
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_STATIC_LIBS:BOOL=${jsonc_static}
    -DBUILD_TESTING:BOOL=OFF
    -DDISABLE_WERROR:BOOL=ON
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DCMAKE_INSTALL_LIBDIR:STRING=lib)
