set(curl_optional_depends)
if (ALLOW_openssl)
  list(APPEND curl_optional_depends
    openssl)
endif ()

superbuild_add_project(curl
  DEPENDS_OPTIONAL ${curl_optional_depends}
  CAN_USE_SYSTEM
  LICENSE_FILES
    COPYING
  CMAKE_ARGS
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DCURL_USE_OPENSSL:BOOL=${openssl_enabled}
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS})
