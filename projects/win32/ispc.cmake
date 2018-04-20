if (ispc_enabled AND NOT MSVC14 AND NOT MSVC12)
  message(FATAL_ERROR "The ispc project requires Visual Studio 2013 or 2015.")
endif ()

include("${CMAKE_CURRENT_LIST_DIR}/../ispc.cmake")
