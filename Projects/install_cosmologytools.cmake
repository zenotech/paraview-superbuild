
execute_process(
    COMMAND ${CMAKE_COMMAND} -E make_directory ${TMP_DIR}/CosmologyToolsPlugin
    WORKING_DIRECTORY ${TMP_DIR}
)

execute_process(
    COMMAND ${CMAKE_COMMAND} -E copy ${BINARY_DIR}/libs/libPVCosmologyToolsPlugins.so ${TMP_DIR}/CosmologyToolsPlugin
    WORKING_DIRECTORY ${TMP_DIR}
)

execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar cvfz ${bundle_name} ${TMP_DIR}/CosmologyToolsPlugin
    WORKING_DIRECTORY ${TMP_DIR}
)
