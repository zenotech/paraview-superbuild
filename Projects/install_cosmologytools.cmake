
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
  execute_process(
    COMMAND ${CMAKE_CURRENT_LIST_DIR}/apple/fixup_plugin.py
            # The directory containing the plugin dylibs.
            ${TMP_DIR}/CosmologyToolsPlugin
            # names to replace.
            "${PARAVIEW_BINARY_DIR}/lib=@executable_path/../Libraries"
            "${INSTALL_DIR}/lib=@executable_path/../Libraries"
            )
endif()

execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar cvz ${bundle_name} CosmologyToolsPlugin
    WORKING_DIRECTORY ${TMP_DIR}
)
