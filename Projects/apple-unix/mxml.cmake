if(BUILD_SHARED_LIBS)
  set(shared_flags --enable-shared)
else()
  set(shared_flags --disable-shared)
endif()

add_external_project_or_use_system(
  mxml
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    ${shared_args}
  PROCESS_ENVIRONMENT
    CC     "${CMAKE_C_COMPILER}"
    CXX    "${CMAKE_CXX_COMPILER}"
)
