

# set extra cpack variables before calling paraview.bundle.common
set (CPACK_GENERATOR DragNDrop)

# include some common stub.
include(paraview.bundle.common)
include(CPack)

# now fixup each of the applications.
# we only to paraview explicitly.
install(CODE "
              file(INSTALL DESTINATION \"\${CMAKE_INSTALL_PREFIX}\" USE_SOURCE_PERMISSIONS TYPE DIRECTORY FILES
                   \"${install_location}/Applications/paraview.app\")
              file(WRITE \"\${CMAKE_INSTALL_PREFIX}/paraview.app/Contents/Resources/qt.conf\"
                         \"\")
              execute_process(
                COMMAND ${CMAKE_CURRENT_LIST_DIR}/fixup_bundle.py
                        \"\${CMAKE_INSTALL_PREFIX}/paraview.app\"
                        \"${install_location}/lib\"
                        \"${install_location}/plugins\")
   "
   COMPONENT superbuild)


add_test(NAME GenerateParaViewPackage
         COMMAND ${CMAKE_CPACK_COMMAND} -G DragNDrop -V
         WORKING_DIRECTORY ${ParaViewSuperBuild_BINARY_DIR})
set_tests_properties(GenerateParaViewPackage PROPERTIES
                     # needed so that tests are run on typical paraview
                     # dashboards
                     LABELS "PARAVIEW"
                     TIMEOUT 1200) # increase timeout to 20 mins.
