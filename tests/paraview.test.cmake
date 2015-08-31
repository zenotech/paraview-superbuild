#------------------------------------------------------------------------------
set(paraview_extract_dir "${CMAKE_CURRENT_BINARY_DIR}/test-extraction")
if (WIN32)
  set(generator "ZIP")
  set(paraview_exe "${paraview_extract_dir}/bin/paraview.exe")
  set(pvpython_exe "${paraview_extract_dir}/bin/pvpython.exe")
  set(pvserver_exe "${paraview_extract_dir}/bin/pvserver.exe")
  set(pvbatch_exe  "${paraview_extract_dir}/bin/pvbatch.exe")
elseif (APPLE)
  set(generator "DragNDrop")
  set(paraview_exe "${paraview_extract_dir}/paraview.app/Contents/MacOS/paraview")
  set(pvpython_exe "${paraview_extract_dir}/paraview.app/Contents/bin/pvpython")
  set(pvserver_exe "${paraview_extract_dir}/paraview.app/Contents/bin/pvserver")
  set(pvbatch_exe  "${paraview_extract_dir}/paraview.app/Contents/bin/pvbatch")
else ()
  set(generator "TGZ")
  set(glob_pattern "ParaView*.tar.gz")
  set(paraview_exe "${paraview_extract_dir}/bin/paraview")
  set(pvpython_exe "${paraview_extract_dir}/bin/pvpython")
  set(pvserver_exe "${paraview_extract_dir}/bin/pvserver")
  set(pvbatch_exe  "${paraview_extract_dir}/bin/pvbatch")
endif ()

superbuild_add_extract_test("${generator}" "${paraview_extract_dir}"
  LABEL "PARAVIEW")
set(paraview_tests)

set(gui_enabled FALSE)
if (qt4_enabled OR qt5_enabled)
  set(gui_enabled TRUE)
endif ()

#------------------------------------------------------------------------------
# Simple test to launch the application and load all plugins.
add_test(
  NAME    paraview-testui
  COMMAND "${paraview_exe}"
          "-dr"
          "--test-directory=${CMAKE_BINARY_DIR}/Testing/Temporary"
          "--test-script=${CMAKE_CURRENT_LIST_DIR}/xml/TestUI.xml"
          "--exit")
list(APPEND paraview_tests
  paraview-testui)

#------------------------------------------------------------------------------
# Simple test to test pvpython/pvbatch.
if (python_enabled)
  add_test(
    NAME    paraview-pvpython
    COMMAND "${pvpython_exe}"
            "${CMAKE_CURRENT_LIST_DIR}/python/basic_python.py")
  list(APPEND paraview_tests
    paraview-pvpython)

  if (NOT WIN32)
    # MSMPI has issues with pvbatch.
    add_test(
      NAME    paraview-pvbatch
      COMMAND "${pvbatch_exe}"
              "${CMAKE_CURRENT_LIST_DIR}/python/basic_python.py")
    list(APPEND paraview_tests
      paraview-pvbatch)
  endif ()
endif ()

#----------------------------------------------------------------------------
# Test to load various data files to ensure reader support.
if (cgns_enabled AND gui_enabled)
  add_test(
    NAME    paraview-data-csg.silo
    COMMAND "${paraview_exe}"
            "-dr"
            "--data=${CMAKE_CURRENT_LIST_DIR}/data/csg.silo"
            "--test-directory=${CMAKE_BINARY_DIR}/Testing/Temporary"
            "--test-script=${CMAKE_CURRENT_LIST_DIR}/xml/TestData-cs_silo.xml"
            "--exit")
  list(APPEND paraview_tests
    paraview-data-csg.silo)

  #----------------------------------------------------------------------------
  add_test(
    NAME    paraview-data-5blocks.cgns
    COMMAND "${paraview_exe}"
            "-dr"
            "--data=${CMAKE_CURRENT_LIST_DIR}/data/5blocks.cgns"
            "--test-directory=${CMAKE_BINARY_DIR}/Testing/Temporary"
            "--test-script=${CMAKE_CURRENT_LIST_DIR}/xml/TestData-5blocks_cgns.xml"
            "--exit")
  list(APPEND paraview_tests
    paraview-data-5blocks.cgns)
endif ()

#----------------------------------------------------------------------------
# Disabling this test for now since the Data file is too big. We probably need
# to add support for Data repository similar to ParaView/VTK soon.
if (gui_enabled AND xdmf3_enabled AND FALSE)
  add_test(
    NAME    paraview-data-Scenario1_p1.xmf
    COMMAND "${paraview_exe}"
            "-dr"
            "--data=${CMAKE_CURRENT_LIST_DIR}/data/Scenario1_p1.xmf"
            "--test-directory=${CMAKE_BINARY_DIR}/Testing/Temporary"
            "--test-script=${CMAKE_CURRENT_LIST_DIR}/xml/TestData.xml"
            "--exit")
  list(APPEND paraview_tests
    paraview-data-Scenario1_p1.xmf)
endif ()

#----------------------------------------------------------------------------
if (matplotlib_enabled)
  add_test(
    NAME    paraview-matplotlib
    COMMAND "${paraview_exe}"
            "-dr"
            "--test-directory=${CMAKE_BINARY_DIR}/Testing/Temporary"
            "--test-script=${CMAKE_CURRENT_LIST_DIR}/xml/TestMatplotlib.xml"
            "--test-baseline=${CMAKE_CURRENT_LIST_DIR}/baselines/Superbuild-TestMatplotlib.png"
            "--exit")
  list(APPEND paraview_tests
    paraview-matplotlib)
endif ()

#----------------------------------------------------------------------------
if (python_enabled)
  add_test(
    NAME    paraview-pythonview
    COMMAND "${paraview_exe}"
            "-dr"
            "--test-directory=${CMAKE_BINARY_DIR}/Testing/Temporary"
            "--test-script=${CMAKE_CURRENT_LIST_DIR}/xml/TestPythonView.xml"
            "--test-baseline=${CMAKE_CURRENT_LIST_DIR}/baselines/TestPythonView.png"
            "--exit")
  list(APPEND paraview_tests
    paraview-pythonview)
endif ()

#----------------------------------------------------------------------------
if (gui_enabled)
  add_test(
   NAME    paraview-finddata
   COMMAND "${paraview_exe}"
           "-dr"
           "--test-directory=${CMAKE_BINARY_DIR}/Testing/Temporary"
           "--test-script=${CMAKE_CURRENT_LIST_DIR}/xml/TestFindData.xml"
           "--test-baseline=${CMAKE_CURRENT_LIST_DIR}/baselines/Superbuild-TestFindData.png"
           "--exit")
 list(APPEND paraview_tests
   paraview-finddata)
endif ()

#----------------------------------------------------------------------------
add_test(
  NAME    paraview-version-server
  COMMAND "${pvserver_exe}"
          "--version")
list(APPEND paraview_tests
  paraview-version-server)

#----------------------------------------------------------------------------
if (gui_enabled)
  add_test(
    NAME    paraview-version-client
    COMMAND "${paraview_exe}"
            "--version")
  list(APPEND paraview_tests
    paraview-version-client)
endif ()

#----------------------------------------------------------------------------
set_tests_properties(${paraview_tests}
  PROPERTIES
    LABELS  "PARAVIEW"
    DEPENDS "extract-${generator}")
