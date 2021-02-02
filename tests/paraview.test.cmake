set(paraview_extract_dir "${CMAKE_CURRENT_BINARY_DIR}/paraview/test-extraction")
if (WIN32)
  set(generator "ZIP")
  set(paraview_exe "${paraview_extract_dir}/bin/paraview.exe")
  set(pvpython_exe "${paraview_extract_dir}/bin/pvpython.exe")
  set(pvserver_exe "${paraview_extract_dir}/bin/pvserver.exe")
  set(pvbatch_exe  "${paraview_extract_dir}/bin/pvbatch.exe")
elseif (APPLE)
  set(generator "DragNDrop")
  include(paraview-appname)
  set(paraview_exe "${paraview_extract_dir}/${paraview_appname}/Contents/MacOS/paraview")
  set(pvpython_exe "${paraview_extract_dir}/${paraview_appname}/Contents/bin/pvpython")
  set(pvserver_exe "${paraview_extract_dir}/${paraview_appname}/Contents/bin/pvserver")
  set(pvbatch_exe  "${paraview_extract_dir}/${paraview_appname}/Contents/bin/pvbatch")
else ()
  set(generator "TGZ")
  set(paraview_exe "${paraview_extract_dir}/bin/paraview")
  set(pvpython_exe "${paraview_extract_dir}/bin/pvpython")
  set(pvserver_exe "${paraview_extract_dir}/bin/pvserver")
  set(pvbatch_exe  "${paraview_extract_dir}/bin/pvbatch")
endif ()

if (PARAVIEW_PACKAGE_FILE_NAME)
  set(glob_prefix "${PARAVIEW_PACKAGE_FILE_NAME}")
else ()
  include(paraview.suffix)
  set(glob_prefix "ParaView-${paraview_version_full}*")
  if (PARAVIEW_PACKAGE_SUFFIX)
    set(glob_prefix "${glob_prefix}-${PARAVIEW_PACKAGE_SUFFIX}")
  endif ()
endif ()
superbuild_add_extract_test("paraview" "${glob_prefix}" "${generator}" "${paraview_extract_dir}"
  LABELS "ParaView")

if (NOT qt5_enabled)
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
  set_tests_properties(paraview-${name}
    PROPERTIES
      LABELS  "ParaView"
      DEPENDS "extract-paraview-${generator}")
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

# Simple test to test paraviewweb.
if (paraviewweb_enabled)
  paraview_add_python_test("pvweb" "basic_paraviewweb")

  if (paraviewwebvisualizer_enabled)
    set(PROJECT_DIR "${CMAKE_BINARY_DIR}/superbuild/paraviewwebvisualizer/src")
    set(SERVER_SCRIPT "${PROJECT_DIR}/server/pvw-visualizer.py")
    set(CONTENT_DIR "${PROJECT_DIR}/dist")
    paraview_add_test("pvweb-visualizer" "${pvpython_exe}"
      "${SERVER_SCRIPT}"
      "--port" "8082"
      "--timeout" "10"
      "--content" "${CONTENT_DIR}")
  endif ()
endif ()

if (numpy_enabled)
  paraview_add_python_test("import-numpy" "import_numpy")
endif ()

if (scipy_enabled)
  paraview_add_python_test("import-scipy" "import_scipy")
endif ()

if (matplotlib_enabled)
  paraview_add_python_test("import-matplotlib" "import_matplotlib")
endif ()

if (mpi_enabled AND python_enabled)
  paraview_add_python_test("import-mpi4py" "import_mpi4py")
endif ()

if (pythonpandas_enabled)
  paraview_add_python_test("import-pandas" "import_pandas")
endif ()

if (openpmd_enabled)
  paraview_add_python_test("import-openpmd" "import_openpmd")
endif ()

# Test to load various data files to ensure reader support.
paraview_add_ui_test("data-csg.silo" "TestData-cs_silo"
  "--data=${CMAKE_CURRENT_LIST_DIR}/data/csg.silo")
paraview_add_ui_test("data-5blocks.cgns" "TestData-5blocks_cgns"
  "--data=${CMAKE_CURRENT_LIST_DIR}/data/5blocks.cgns")

# Disabling this test for now since the Data file is too big. We probably need
# to add support for Data repository similar to ParaView/VTK soon.
if (xdmf3_enabled AND FALSE)
  paraview_add_ui_test("data-scenario1_p1.xmf" "TestData"
    "--data=${CMAKE_CURRENT_LIST_DIR}/data/Scenario1_p1.xmf")
endif ()

if (matplotlib_enabled)
  paraview_add_ui_test("matplotlib" "TestMatplotlib"
    "--test-baseline=${CMAKE_CURRENT_LIST_DIR}/baselines/Superbuild-TestMatplotlib.png"
    "--test-threshold=15")
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

if (mesa_enabled AND python_enabled)
  set(mesa_llvm_arg)
  set(mesa_swr_arg)
  if (launchers_enabled)
    set(mesa_llvm_arg --mesa --backend llvmpipe)
    set(mesa_swr_arg --mesa --backend swr)
  endif ()

  paraview_add_test("mesa-llvm" ${pvpython_exe}
    ${mesa_llvm_arg}
    "${CMAKE_CURRENT_LIST_DIR}/python/CheckOpenGLVersion.py"
    "mesa" "llvmpipe")
  if (mesa_USE_SWR)
    # Either don't add or add but explicitly disable this test for now
    # until the underlying VTK segfault is fixed.
    if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.9)
      paraview_add_test("mesa-swr" "${pvpython_exe}"
        ${mesa_swr_arg}
        "${CMAKE_CURRENT_LIST_DIR}/python/CheckOpenGLVersion.py"
        "mesa" "swr")
      # Mesa exits with failure.
      set_tests_properties(paraview-mesa-swr PROPERTIES
        PASS_REGULAR_EXPRESSION "SWR (detected|could not initialize)"
        DISABLED TRUE)
    endif ()
  endif ()
endif ()

paraview_add_ui_test("loaddistributedplugins" "LoadDistributedPlugins"
  "--test-baseline=${CMAKE_CURRENT_LIST_DIR}/baselines/LoadDistributedPlugins.png")

if (vortexfinder2_enabled)
  paraview_add_ui_test("loadvortexfinderplugins" "LoadVortexFinderPlugins")
endif ()

if (vtkm_enabled)
  paraview_add_ui_test("vtkm-contour" "VTKmContour"
    --test-plugin=VTKmFilters)
  paraview_add_ui_test("vtkm-gradient" "VTKmGradient"
    --test-plugin=VTKmFilters)
  paraview_add_ui_test("vtkm-threshold" "VTKmThreshold"
    --test-plugin=VTKmFilters)
endif ()

if (fides_enabled)
  paraview_add_ui_test("fides" "FidesReaderADIOS2")
endif()
