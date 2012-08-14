
execute_process(
  COMMAND ${CMAKE_COMMAND} -E make_directory ${TMP_DIR}/VisTrailsPlugin
  COMMAND ${CMAKE_COMMAND} -E copy ${SOURCE_DIR}/README ${TMP_DIR}/VisTrailsPlugin
  COMMAND ${CMAKE_COMMAND} -E copy ${BINARY_DIR}/gui/qt/libVisTrailsGUI.so ${TMP_DIR}/VisTrailsPlugin
  COMMAND ${CMAKE_COMMAND} -E copy ${BINARY_DIR}/capi/src/libVisTrails.so ${TMP_DIR}/VisTrailsPlugin
  COMMAND ${CMAKE_COMMAND} -E copy ${BINARY_DIR}/paraviewplugin/quazip/libvtquazip.so ${TMP_DIR}/VisTrailsPlugin
  COMMAND ${CMAKE_COMMAND} -E copy ${BINARY_DIR}/paraviewplugin/libVisTrailsPlugin.so ${TMP_DIR}/VisTrailsPlugin
  COMMAND ${CMAKE_COMMAND} -E tar cvfz ${bundle_name} ${TMP_DIR}/VisTrailsPlugin
  WORKING_DIRECTORY ${TMP_DIR})

