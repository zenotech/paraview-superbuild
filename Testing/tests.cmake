# This needs the following variables to be set.
#   PARAVIEW_EXECUTABLE
#   PVPYTHON_EXECUTABLE
#   PVSERVER_EXECUTABLE
#   PVBATCH_EXECUTABLE

#------------------------------------------------------------------------------
set (INSTALLED_PACKAGE_ROOT "${CMAKE_CURRENT_BINARY_DIR}/InstalledPackageRoot")

if(WIN32)
  set (glob_pattern "ParaView*.zip")
  set (package_generation_test "GenerateParaViewPackage-ZIP")
  set (PARAVIEW_EXECUTABLE "${INSTALLED_PACKAGE_ROOT}/bin/paraview.exe")
  set (PVPYTHON_EXECUTABLE "${INSTALLED_PACKAGE_ROOT}/bin/pvpython.exe")
  set (PVSERVER_EXECUTABLE "${INSTALLED_PACKAGE_ROOT}/bin/pvserver.exe")
  set (PVBATCH_EXECUTABLE  "${INSTALLED_PACKAGE_ROOT}/bin/pvbatch.exe")
elseif(APPLE)
  set (glob_pattern "ParaView*.dmg")
  set (package_generation_test "GenerateParaViewPackage")
  set (PARAVIEW_EXECUTABLE "${INSTALLED_PACKAGE_ROOT}/paraview.app/Contents/MacOS/paraview")
  set (PVPYTHON_EXECUTABLE "${INSTALLED_PACKAGE_ROOT}/paraview.app/Contents/bin/pvpython")
  set (PVSERVER_EXECUTABLE "${INSTALLED_PACKAGE_ROOT}/paraview.app/Contents/bin/pvserver")
  set (PVBATCH_EXECUTABLE  "${INSTALLED_PACKAGE_ROOT}/paraview.app/Contents/bin/pvbatch")
else()
  set (glob_pattern "ParaView*.tar.gz")
  set (package_generation_test "GenerateParaViewPackage")
  set (PARAVIEW_EXECUTABLE "${INSTALLED_PACKAGE_ROOT}/bin/paraview")
  set (PVPYTHON_EXECUTABLE "${INSTALLED_PACKAGE_ROOT}/bin/pvpython")
  set (PVSERVER_EXECUTABLE "${INSTALLED_PACKAGE_ROOT}/bin/pvserver")
  set (PVBATCH_EXECUTABLE  "${INSTALLED_PACKAGE_ROOT}/bin/pvbatch")
endif()

add_test(NAME PrepareBinariesForTesting
  COMMAND ${CMAKE_COMMAND}
          -DBINARY_DIRECTORY:PATH=${ParaViewSuperBuild_BINARY_DIR}
          -DOUTPUT_DIRECTORY:PATH=${INSTALLED_PACKAGE_ROOT}
          -DGLOB_PATTERN:STRING=${glob_pattern}
          -P ${CMAKE_CURRENT_LIST_DIR}/PrepareBinaries.cmake
          )
set_tests_properties(PrepareBinariesForTesting PROPERTIES
                     LABELS "PARAVIEW" DEPENDS ${package_generation_test})

#------------------------------------------------------------------------------
# Simple test to launch the application and load all plugins.
add_test(NAME TestUI
         COMMAND "${PARAVIEW_EXECUTABLE}"
                 "-dr"
                 "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                 "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestUI.xml"
                 "--exit")
set_tests_properties(TestUI PROPERTIES
                     LABELS "PARAVIEW" DEPENDS "PrepareBinariesForTesting")

#------------------------------------------------------------------------------
# Simple test to test paraviewweb.
#
#  if (NOT WIN32)
#    # we don't package ParaViewWeb on Windows anymore.
#    add_test(NAME Test-pvweb
#             COMMAND "${PVPYTHON_EXECUTABLE}"
#                     "${CMAKE_CURRENT_SOURCE_DIR}/basic_paraviewweb.py")
#    set_tests_properties(Test-pvweb PROPERTIES
#                         LABELS "PARAVIEW" DEPENDS "PrepareBinariesForTesting")
#  endif()
#------------------------------------------------------------------------------
# Simple test to test pvpython/pvbatch.
add_test(NAME Test-pvpython
         COMMAND "${PVPYTHON_EXECUTABLE}"
                 "${CMAKE_CURRENT_SOURCE_DIR}/basic_python.py")
set_tests_properties(Test-pvpython PROPERTIES
                     LABELS "PARAVIEW" DEPENDS "PrepareBinariesForTesting")

if (NOT WIN32)
  # Windows MPI has issues with pvbatch.
  add_test(NAME Test-pvbatch
           COMMAND "${PVBATCH_EXECUTABLE}"
                   "${CMAKE_CURRENT_SOURCE_DIR}/basic_python.py")
  set_tests_properties(Test-pvbatch PROPERTIES
                       LABELS "PARAVIEW" DEPENDS "PrepareBinariesForTesting")
endif()

# Test to load various data files to ensure reader support.
#----------------------------------------------------------------------------
add_test(NAME TestData-csg.silo
         COMMAND "${PARAVIEW_EXECUTABLE}"
                 "-dr"
                 "--data=${CMAKE_CURRENT_SOURCE_DIR}/Data/csg.silo"
                 "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                 "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestData-cs_silo.xml"
                 "--exit")
set_tests_properties(TestData-csg.silo PROPERTIES
                     LABELS "PARAVIEW" DEPENDS "PrepareBinariesForTesting")

#----------------------------------------------------------------------------
add_test(NAME TestData-5blocks.cgns
         COMMAND "${PARAVIEW_EXECUTABLE}"
                 "-dr"
                 "--data=${CMAKE_CURRENT_SOURCE_DIR}/Data/5blocks.cgns"
                 "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                 "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestData-5blocks_cgns.xml"
                 "--exit")
set_tests_properties(TestData-5blocks.cgns PROPERTIES
                     LABELS "PARAVIEW" DEPENDS "PrepareBinariesForTesting")

#----------------------------------------------------------------------------
# Disabling this test for now since the Data file is too big. We probably need
# to add support for Data repository similar to ParaView/VTK soon.
#add_test(NAME TestData-Scenario1_p1.xmf
#         COMMAND "${PARAVIEW_EXECUTABLE}"
#                 "-dr"
#                 "--data=${CMAKE_CURRENT_SOURCE_DIR}/Data/Scenario1_p1.xmf"
#                 "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
#                 "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestData.xml"
#                 "--exit")
#set_tests_properties(TestData-Scenario1_p1.xmf PROPERTIES
#         LABELS "PARAVIEW" DEPENDS "PrepareBinariesForTesting")



#----------------------------------------------------------------------------
add_test(NAME TestMatplotlib
         COMMAND "${PARAVIEW_EXECUTABLE}"
                 "-dr"
                 "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                 "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestMatplotlib.xml"
                 "--test-baseline=${CMAKE_CURRENT_SOURCE_DIR}/Baselines/Superbuild-TestMatplotlib.png"
                 "--exit")
set_tests_properties(TestMatplotlib PROPERTIES
                     LABELS "PARAVIEW" DEPENDS "PrepareBinariesForTesting")

#----------------------------------------------------------------------------
add_test(NAME TestPythonView
         COMMAND "${PARAVIEW_EXECUTABLE}"
                 "-dr"
                 "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                 "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestPythonView.xml"
                 "--test-baseline=${CMAKE_CURRENT_SOURCE_DIR}/Baselines/TestPythonView.png"
                 "--exit")
set_tests_properties(TestPythonView PROPERTIES
                     LABELS "PARAVIEW" DEPENDS "PrepareBinariesForTesting")

#----------------------------------------------------------------------------
add_test(NAME TestFindData
         COMMAND "${PARAVIEW_EXECUTABLE}"
                 "-dr"
                 "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                 "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestFindData.xml"
                 "--test-baseline=${CMAKE_CURRENT_SOURCE_DIR}/Baselines/Superbuild-TestFindData.png"
                 "--exit")
set_tests_properties(TestFindData PROPERTIES
                     LABELS "PARAVIEW" DEPENDS "PrepareBinariesForTesting")

#----------------------------------------------------------------------------
add_test(NAME PrintVersionServer COMMAND "${PVSERVER_EXECUTABLE}" "--version")
set_tests_properties(PrintVersionServer PROPERTIES
                     LABELS "PARAVIEW" DEPENDS "PrepareBinariesForTesting")

#----------------------------------------------------------------------------
add_test(NAME PrintVersionClient COMMAND "${PARAVIEW_EXECUTABLE}" "--version")
set_tests_properties(PrintVersionClient PROPERTIES
                     LABELS "PARAVIEW" DEPENDS "PrepareBinariesForTesting")
