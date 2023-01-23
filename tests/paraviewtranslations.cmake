execute_process(COMMAND ${paraview_exe} --test-directory=${test_directory}
  --test-script=${test_xml_set} --exit
  RESULT_VARIABLE status_code)
if (status_code)
  message(FATAL_ERROR "Could not change the client language")
endif()

execute_process(COMMAND ${paraview_exe} --test-directory=${test_directory}
  --test-script=${test_xml_check} --exit
  RESULT_VARIABLE status_code)

if (status_code)
  message(FATAL_ERROR "ParaView interface language has not changed")
endif()
