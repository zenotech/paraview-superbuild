
execute_process(
    COMMAND ${CMAKE_COMMAND} -E make_directory ${TMP_DIR}/CosmologyToolsPlugin
    WORKING_DIRECTORY ${TMP_DIR}
)

if (UNIX AND NOT APPLE)
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E copy ${BINARY_DIR}/libs/libPVCosmologyToolsPlugins.so ${TMP_DIR}/CosmologyToolsPlugin
    WORKING_DIRECTORY ${TMP_DIR}
  )
endif()

if (APPLE)
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E copy ${BINARY_DIR}/libs/libPVCosmologyToolsPlugins.dylib ${TMP_DIR}/CosmologyToolsPlugin
    WORKING_DIRECTORY ${TMP_DIR}
  )
endif()

execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar cvfz ${bundle_name} ${TMP_DIR}/CosmologyToolsPlugin
    WORKING_DIRECTORY ${TMP_DIR}
)
