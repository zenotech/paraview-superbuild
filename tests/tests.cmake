# This needs the following variables to be set.
#   PV_NIGHTLY_PARAVIEW
#   PV_NIGHTLY_PVPYTHON
#   PV_NIGHTLY_PVSERVER
#   PV_NIGHTLY_PVBATCH
#   PV_NIGHTLY_PVBLOT
#   PV_NIGHTLY_PVDATASERVER
#   PV_NIGHTLY_PVRENDERSERVER

find_path(PARAVIEW_DATA_ROOT ParaViewData.readme
  ${ParaView_SOURCE_DIR}/../ParaViewData
  ${ParaView_BINARY_DIR}/../ParaViewData
  $ENV{PARAVIEW_DATA_ROOT})

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
                     "--testurls=${REMOTE_PVWEB_VISUALIZER_URLS}")
    set_tests_properties(Test-pvweb-autodeploy PROPERTIES LABELS "PARAVIEW")
  endif()
endif()

#------------------------------------------------------------------------------
# Simple test to test paraviewweb.
add_test(NAME Test-pvweb
         COMMAND "${PV_NIGHTLY_PVPYTHON}"
                 "${CMAKE_CURRENT_SOURCE_DIR}/basic_paraviewweb.py")
set_tests_properties(Test-pvweb PROPERTIES LABELS "PARAVIEW")

#------------------------------------------------------------------------------
# Simple test to test pvpython/pvbatch.
add_test(NAME Test-pvpython
         COMMAND "${PV_NIGHTLY_PVPYTHON}"
                 "${CMAKE_CURRENT_SOURCE_DIR}/basic_python.py")
set_tests_properties(Test-pvpython PROPERTIES LABELS "PARAVIEW")

add_test(NAME Test-pvbatch
         COMMAND "${PV_NIGHTLY_PVBATCH}"
                 "${CMAKE_CURRENT_SOURCE_DIR}/basic_python.py")
set_tests_properties(Test-pvbatch PROPERTIES LABELS "PARAVIEW")

if (PARAVIEW_DATA_ROOT)
  # Test to load various data files to ensure reader support.
  #----------------------------------------------------------------------------
  add_test(NAME TestData-csg.silo
           COMMAND "${PV_NIGHTLY_PARAVIEW}"
                   "-dr"
                   "--data=${PARAVIEW_DATA_ROOT}/Data/VisItBridge/csg.silo"
                   "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                   "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestData-cs_silo.xml"
                   "--exit")
  set_tests_properties(TestData-csg.silo PROPERTIES LABELS "PARAVIEW")

  #----------------------------------------------------------------------------
  add_test(NAME TestData-5blocks.cgns
           COMMAND "${PV_NIGHTLY_PARAVIEW}"
                   "-dr"
                   "--data=${PARAVIEW_DATA_ROOT}/Data/VisItBridge/5blocks.cgns"
                   "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                   "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestData-5blocks_cgns.xml"
                   "--exit")
  set_tests_properties(TestData-5blocks.cgns PROPERTIES LABELS "PARAVIEW")

  #----------------------------------------------------------------------------
  add_test(NAME TestData-Scenario1_p1.xmf
           COMMAND "${PV_NIGHTLY_PARAVIEW}"
                   "-dr"
                   "--data=${PARAVIEW_DATA_ROOT}/Data/Scenario1_p1.xmf"
                   "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                   "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestData.xml"
                   "--exit")
  set_tests_properties(TestData-Scenario1_p1.xmf PROPERTIES LABELS "PARAVIEW")

  #----------------------------------------------------------------------------
  add_test(NAME TestMatplotlib
           COMMAND "${PV_NIGHTLY_PARAVIEW}"
                   "-dr"
                   "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                   "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestMatplotlib.xml"
                   "--test-baseline=${PARAVIEW_DATA_ROOT}/Baseline/Superbuild-TestMatplotlib.png"
                   "--exit")
  set_tests_properties(TestMatplotlib PROPERTIES LABELS "PARAVIEW")

  #----------------------------------------------------------------------------
  add_test(NAME TestPythonView
           COMMAND "${PV_NIGHTLY_PARAVIEW}"
                   "-dr"
                   "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                   "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestPythonView.xml"
                   "--test-baseline=${PARAVIEW_DATA_ROOT}/Baseline/TestPythonView.png"
                   "--exit")
  set_tests_properties(TestPythonView PROPERTIES LABELS "PARAVIEW")

  #----------------------------------------------------------------------------
  add_test(NAME TestFindData
           COMMAND "${PV_NIGHTLY_PARAVIEW}"
                   "-dr"
                   "--test-directory=${SuperBuild_BINARY_DIR}/Testing/Temporary"
                   "--test-script=${CMAKE_CURRENT_SOURCE_DIR}/TestFindData.xml"
                   "--test-baseline=${PARAVIEW_DATA_ROOT}/Baseline/Superbuild-TestFindData.png"
                   "--exit")
  set_tests_properties(TestFindData PROPERTIES LABELS "PARAVIEW")

endif()
