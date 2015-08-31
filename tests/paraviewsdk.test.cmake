#------------------------------------------------------------------------------
# Test to check install tree for paraviewsdk
#------------------------------------------------------------------------------
set(paraview_source_dir "<SOURCE_DIR>")
set(paraview_binary_dir "<BINARY_DIR>")
_ep_replace_location_tags(paraview paraview_source_dir)
_ep_replace_location_tags(paraview paraview_binary_dir)

add_test(
  NAME    paraviewsdk-install
  COMMAND "${CMAKE_COMMAND}"
          -DPARAVIEW_BINARY_DIR:PATH=${paraview_binary_dir}
          -DPARAVIEW_INSTALL_DIR:PATH=${superbuild_install_directory}
          -DPARAVIEW_SOURCE_DIR:PATH=${paraview_source_dir}
          -DPARAVIEW_TEST_DIR:PATH=${CMAKE_BINARY_DIR}/Testing/Temporary
          -DPARAVIEW_VERSION:STRING=${paraview_version}
          -P ${CMAKE_CURRENT_LIST_DIR}/scripts/paraviewsdk.test.install.cmake)
set_tests_properties(paraviewsdk-install
  PROPERTIES
    LABELS  "PARAVIEW"
    TIMEOUT 1500)
