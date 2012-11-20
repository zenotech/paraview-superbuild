if (APPLE)
  set (SHARED_LIBRARY_PREFIX "lib")
  set (SHARED_LIBRARY_SUFFIX ".dylib")
  set (PLUGIN_DIR "lib")
elseif (UNIX)
  set (SHARED_LIBRARY_PREFIX "lib")
  set (SHARED_LIBRARY_SUFFIX ".so")
  set (PLUGIN_DIR "lib")
elseif (WIN32)
  set (SHARED_LIBRARY_PREFIX "")
  set (SHARED_LIBRARY_SUFFIX ".dll")
  set (PLUGIN_DIR "bin")
endif()

execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${TMP_DIR}/VisTrailsPlugin)
execute_process(COMMAND ${CMAKE_COMMAND} -E copy ${SOURCE_DIR}/README ${TMP_DIR}/VisTrailsPlugin)
execute_process(COMMAND ${CMAKE_COMMAND} -E copy ${BINARY_DIR}/${PLUGIN_DIR}/${SHARED_LIBRARY_PREFIX}VisTrailsPlugin${SHARED_LIBRARY_SUFFIX} ${TMP_DIR}/VisTrailsPlugin)

if (APPLE)
  execute_process(
    COMMAND ${CMAKE_CURRENT_LIST_DIR}/apple/fixup_plugin.py
            # The directory containing the plugin dylibs.
            ${TMP_DIR}/VisTrailsPlugin
            # names to replace.
            "${PARAVIEW_BINARY_DIR}/lib=@executable_path/../Libraries"
            "${INSTALL_DIR}/lib=@executable_path/../Libraries"
            )
endif()


execute_process(
  COMMAND ${CMAKE_COMMAND} -E tar cvfz ${bundle_name} VisTrailsPlugin
  WORKING_DIRECTORY ${TMP_DIR})
