set (extra_commands)

if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  #set the platform to be clang if on apple and not gcc
  set(extra_commands --with-toolset=clang)
endif()
if(BUILD_SHARED_LIBS)
  list(APPEND extra_commands link=shared)
else()
  list(APPEND extra_commands link=static)
endif()

add_external_project_or_use_system(boost
  DEPENDS zlib
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    <SOURCE_DIR>/bootstrap.sh --prefix=<INSTALL_DIR>
                              --with-libraries=date_time
                              ${extra_commands}
  BUILD_COMMAND <SOURCE_DIR>/bjam
  INSTALL_COMMAND <SOURCE_DIR>/bjam --prefix=<INSTALL_DIR> install
)
unset(extra_commands)
