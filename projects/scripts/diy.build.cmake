file(MAKE_DIRECTORY "${source_location}/lib")
execute_process(
  COMMAND         "make"
  RESULT_VARIABLE res)
if (res)
  message(FATAL_ERROR "Failed to build diy")
endif ()
