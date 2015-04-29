if (ENABLE_python)
  add_external_dummy_project(zlib
    DEPENDS python)

  add_extra_cmake_args(
    -DZLIB_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/zlib.lib
    -DZLIB_INCLUDE_DIR:PATH=<INSTALL_DIR>/include)
else ()
  include("${PROJECT_SOURCE_DIR}/Projects/zlib.cmake")
endif ()
