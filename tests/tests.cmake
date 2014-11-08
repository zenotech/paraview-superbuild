# This needs the following variables to be set.
#   PV_NIGHTLY_PARAVIEW
#   PV_NIGHTLY_PVPYTHON
#   PV_NIGHTLY_PVSERVER
#   PV_NIGHTLY_PVBATCH
#   PV_NIGHTLY_PVBLOT
#   PV_NIGHTLY_PVDATASERVER
#   PV_NIGHTLY_PVRENDERSERVER

#------------------------------------------------------------------------------
# Simple test to launch the application and load all plugins.
add_test(NAME TestUI
         COMMAND "${PV_NIGHTLY_PARAVIEW}"
                 "-dr"
                 "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                 "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestUI.xml"
                 "--exit")
set_tests_properties(TestUI PROPERTIES LABELS "PARAVIEW")

#------------------------------------------------------------------------------
# Simple test of a public, automatically deployed version of paraviewweb.  If
# system python does not have selenium, test will still be added and run, but
# will be allowed to pass only in the case of missing python modules.  In the
# future we can set here a SKIP_RETURN_CODE to allow the test to return a
# value which will indicate to CTest that some dependencies were not met.
if(ENABLE_REMOTE_PVWEB_TEST)
  find_package(PythonInterp 2.7)
  if(PYTHON_EXECUTABLE)
    add_test(NAME Test-pvweb-autodeploy
             COMMAND "${PYTHON_EXECUTABLE}"
                     "${CMAKE_CURRENT_SOURCE_DIR}/../Scripts/pvweb/auto_pvweb_test.py"
                     "--testurls=${REMOTE_PVWEB_VISUALIZER_URLS}"
                     "--browser=${REMOTE_PVWEB_TEST_BROWSER}")
    set_tests_properties(Test-pvweb-autodeploy PROPERTIES LABELS "PARAVIEW")
  endif()
endif()

#------------------------------------------------------------------------------
# Simple test to test paraviewweb.
if (NOT WIN32)
  # we don't package ParaViewWeb on Windows anymore.
  add_test(NAME Test-pvweb
           COMMAND "${PV_NIGHTLY_PVPYTHON}"
                   "${CMAKE_CURRENT_SOURCE_DIR}/basic_paraviewweb.py")
  set_tests_properties(Test-pvweb PROPERTIES LABELS "PARAVIEW")
endif()
#------------------------------------------------------------------------------
# Simple test to test pvpython/pvbatch.
add_test(NAME Test-pvpython
         COMMAND "${PV_NIGHTLY_PVPYTHON}"
                 "${CMAKE_CURRENT_SOURCE_DIR}/basic_python.py")
set_tests_properties(Test-pvpython PROPERTIES LABELS "PARAVIEW")

if (NOT WIN32)
  # Windows MPI has issues with pvbatch.
  add_test(NAME Test-pvbatch
           COMMAND "${PV_NIGHTLY_PVBATCH}"
                   "${CMAKE_CURRENT_SOURCE_DIR}/basic_python.py")
  set_tests_properties(Test-pvbatch PROPERTIES LABELS "PARAVIEW")
endif()

# Test to load various data files to ensure reader support.
#----------------------------------------------------------------------------
add_test(NAME TestData-csg.silo
         COMMAND "${PV_NIGHTLY_PARAVIEW}"
                 "-dr"
                 "--data=${CMAKE_CURRENT_SOURCE_DIR}/Data/csg.silo"
                 "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                 "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestData-cs_silo.xml"
                 "--exit")
set_tests_properties(TestData-csg.silo PROPERTIES LABELS "PARAVIEW")

#----------------------------------------------------------------------------
add_test(NAME TestData-5blocks.cgns
         COMMAND "${PV_NIGHTLY_PARAVIEW}"
                 "-dr"
                 "--data=${CMAKE_CURRENT_SOURCE_DIR}/Data/5blocks.cgns"
                 "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                 "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestData-5blocks_cgns.xml"
                 "--exit")
set_tests_properties(TestData-5blocks.cgns PROPERTIES LABELS "PARAVIEW")

#----------------------------------------------------------------------------
# Disabling this test for now since the Data file is too big. We probably need
# to add support for Data repository similar to ParaView/VTK soon.
#add_test(NAME TestData-Scenario1_p1.xmf
#         COMMAND "${PV_NIGHTLY_PARAVIEW}"
#                 "-dr"
#                 "--data=${CMAKE_CURRENT_SOURCE_DIR}/Data/Scenario1_p1.xmf"
#                 "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
#                 "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestData.xml"
#                 "--exit")
#set_tests_properties(TestData-Scenario1_p1.xmf PROPERTIES LABELS "PARAVIEW")

#----------------------------------------------------------------------------
add_test(NAME TestMatplotlib
         COMMAND "${PV_NIGHTLY_PARAVIEW}"
                 "-dr"
                 "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                 "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestMatplotlib.xml"
                 "--test-baseline=${CMAKE_CURRENT_SOURCE_DIR}/Baselines/Superbuild-TestMatplotlib.png"
                 "--exit")
set_tests_properties(TestMatplotlib PROPERTIES LABELS "PARAVIEW")

#----------------------------------------------------------------------------
add_test(NAME TestPythonView
         COMMAND "${PV_NIGHTLY_PARAVIEW}"
                 "-dr"
                 "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                 "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestPythonView.xml"
                 "--test-baseline=${CMAKE_CURRENT_SOURCE_DIR}/Baselines/TestPythonView.png"
                 "--exit")
set_tests_properties(TestPythonView PROPERTIES LABELS "PARAVIEW")

#----------------------------------------------------------------------------
add_test(NAME TestFindData
         COMMAND "${PV_NIGHTLY_PARAVIEW}"
                 "-dr"
                 "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                 "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestFindData.xml"
                 "--test-baseline=${CMAKE_CURRENT_SOURCE_DIR}/Baselines/Superbuild-TestFindData.png"
                 "--exit")
set_tests_properties(TestFindData PROPERTIES LABELS "PARAVIEW")

#----------------------------------------------------------------------------
add_test(NAME PrintVersionServer
         COMMAND "${PV_NIGHTLY_PVSERVER}"
                 "--version"
        )
set_tests_properties(PrintVersionServer PROPERTIES LABELS "PARAVIEW")
add_test(NAME PrintVersionClient
         COMMAND "${PV_NIGHTLY_PARAVIEW}"
                 "--version"
        )
set_tests_properties(PrintVersionClient PROPERTIES LABELS "PARAVIEW")
