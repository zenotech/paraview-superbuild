file(MAKE_DIRECTORY "${diy_source}/lib")
execute_process(
  COMMAND         "make"
  RESULT_VARIABLE res)
if (res)
  message(FATAL_ERROR "Failed to build diy")
endif ()
