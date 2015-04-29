if (ENABLE_python)
  add_external_dummy_project(bzip2
    DEPENDS python)
else ()
  include("${PROJECT_SOURCE_DIR}/Projects/bzip2.cmake")
endif ()
