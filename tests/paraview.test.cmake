set(paraview_extract_dir "${CMAKE_CURRENT_BINARY_DIR}/paraview/test-extraction")
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
  set(paraview_exe "${paraview_extract_dir}/bin/paraview")
  set(pvpython_exe "${paraview_extract_dir}/bin/pvpython")
  set(pvserver_exe "${paraview_extract_dir}/bin/pvserver")
  set(pvbatch_exe  "${paraview_extract_dir}/bin/pvbatch")
endif ()

include(paraview.suffix)
set(glob_prefix "ParaView-${paraview_version_major}.${paraview_version_minor}.${paraview_version_patch}")
if (PARAVIEW_PACKAGE_SUFFIX)
  set(glob_prefix "${glob_prefix}-${PARAVIEW_PACKAGE_SUFFIX}")
endif ()
superbuild_add_extract_test("paraview" "${glob_prefix}" "${generator}" "${paraview_extract_dir}"
  LABEL "PARAVIEW")

if (NOT (qt4_enabled OR qt5_enabled))
  set(paraview_exe)
endif ()

if (NOT python_enabled)
  set(pvpython_exe)
  set(pvbatch_exe)
endif ()

if (NOT mpi_enabled)
  set(pvbatch_exe)
endif ()

function (paraview_add_test name exe)
  if (NOT exe)
    return ()
  endif ()

  add_test(
    NAME    "paraview-${name}"
    COMMAND "${exe}"
            ${ARGN})
  set_tests_properties(${paraview_tests}
    PROPERTIES
      LABELS  "PARAVIEW"
      DEPENDS "extract-${paraview}-${generator}")
endfunction ()

function (paraview_add_ui_test name script)
  paraview_add_test("${name}" "${paraview_exe}"
    "-dr"
    "--test-directory=${CMAKE_BINARY_DIR}/Testing/Temporary"
    "--test-script=${CMAKE_CURRENT_LIST_DIR}/xml/${script}.xml"
    ${ARGN}
    "--exit")
endfunction ()

function (paraview_add_python_test name script)
  paraview_add_test("${name}" "${pvpython_exe}"
    "${CMAKE_CURRENT_LIST_DIR}/python/${script}.py")
endfunction ()

function (paraview_add_pvbatch_test name script)
  paraview_add_test("${name}" "${pvbatch_exe}"
    "${CMAKE_CURRENT_LIST_DIR}/python/${script}.py")
endfunction ()

# Simple test to launch the application and load all plugins.
paraview_add_ui_test("testui" "TestUI")

# Simple test to test pvpython/pvbatch.
paraview_add_python_test("pvpython" "basic_python")
if (NOT WIN32)
  # MSMPI has issues with pvbatch.
  paraview_add_pvbatch_test("pvbatch" "basic_python")
endif ()

# Test to load various data files to ensure reader support.
if (cgns_enabled)
  paraview_add_ui_test("data-csg.silo" "TestData-cs_silo"
    "--data=${CMAKE_CURRENT_LIST_DIR}/data/csg.silo")
  paraview_add_ui_test("data-5blocks.cgns" "TestData-5blocks_cgns"
    "--data=${CMAKE_CURRENT_LIST_DIR}/data/5blocks.cgns")
endif ()

# Disabling this test for now since the Data file is too big. We probably need
# to add support for Data repository similar to ParaView/VTK soon.
if (xdmf3_enabled AND FALSE)
  paraview_add_ui_test("data-scenario1_p1.xmf" "TestData"
    "--data=${CMAKE_CURRENT_LIST_DIR}/data/Scenario1_p1.xmf")
endif ()

if (matplotlib_enabled)
  paraview_add_ui_test("matplotlib" "TestMatplotlib"
    "--test-baseline=${CMAKE_CURRENT_LIST_DIR}/baselines/Superbuild-TestMatplotlib.png")
endif ()

if (python_enabled)
  paraview_add_ui_test("pythonview" "TestPythonView"
    "--test-baseline=${CMAKE_CURRENT_LIST_DIR}/baselines/TestPythonView.png")
endif ()

if (ospray_enabled)
  paraview_add_ui_test("ospray" "OSPRay"
    "--test-baseline=${CMAKE_CURRENT_LIST_DIR}/baselines/OSPRay.png")
endif ()

paraview_add_ui_test("finddata" "TestFindData"
  "--test-baseline=${CMAKE_CURRENT_LIST_DIR}/baselines/Superbuild-TestFindData.png")

paraview_add_test("version-server" "${pvserver_exe}"
  "--version")
paraview_add_test("version-client" "${paraview_exe}"
  "--version")
