if (APPLE)
  set (SHARED_LIBRARY_PREFIX "lib")
  set (SHARED_LIBRARY_SUFFIX ".dylib")
elseif (UNIX)
  set (SHARED_LIBRARY_PREFIX "lib")
  set (SHARED_LIBRARY_SUFFIX ".so")
elseif(WIN32)
  message(FATAL_ERROR "Not supported on Windows")
endif()

execute_process(
    COMMAND ${CMAKE_COMMAND} -E make_directory ${TMP_DIR}/CosmologyToolsPlugin
    WORKING_DIRECTORY ${TMP_DIR}
)

execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy ${BINARY_DIR}/libs/${SHARED_LIBRARY_PREFIX}PVCosmologyToolsPlugins${SHARED_LIBRARY_SUFFIX} ${TMP_DIR}/CosmologyToolsPlugin
  WORKING_DIRECTORY ${TMP_DIR}
)

if (APPLE)
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
