if (ispc_enabled AND (MSVC_VERSION VERSION_LESS 1800 OR NOT MSVC_VERSION VERSION_LESS 2000))
  message(FATAL_ERROR "The ispc project requires Visual Studio 2013 or 2015.")
endif ()

include("${CMAKE_CURRENT_LIST_DIR}/../ispc.cmake")
