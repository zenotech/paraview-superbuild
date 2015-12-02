if (NOT MSVC12)
  message(FATAL_ERROR "The ispc project requires Visual Studio 2013.")
endif ()

include("${CMAKE_CURRENT_LIST_DIR}/../ispc.cmake")
