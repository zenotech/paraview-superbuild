if (BUILD_SHARED_LIBS)
  set(mxml_shared_flags --enable-shared)
else ()
  set(mxml_shared_flags --disable-shared)
endif ()

superbuild_add_project(mxml
  CAN_USE_SYSTEM
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      ${mxml_shared_args}
  PROCESS_ENVIRONMENT
    CC  "${CMAKE_C_COMPILER}"
    CXX "${CMAKE_CXX_COMPILER}")
