set(paraviewsdk_extract_dir "${CMAKE_CURRENT_BINARY_DIR}/paraviewsdk/test-extraction")
if (WIN32)
  set(generator "ZIP")
elseif (APPLE)
  set(generator "DragNDrop")
else ()
  set(generator "TGZ")
endif ()

if (PARAVIEWSDK_PACKAGE_FILE_NAME)
  set(glob_prefix "${PARAVIEWSDK_PACKAGE_FILE_NAME}")
else ()
  include(paraview.suffix)
  set(glob_prefix "ParaViewSDK-${paraview_version_full}")
  if (PARAVIEW_PACKAGE_SUFFIX)
    set(glob_prefix "${glob_prefix}-${PARAVIEW_PACKAGE_SUFFIX}")
  endif ()
endif ()
superbuild_add_extract_test("paraviewsdk" "${glob_prefix}" "TGZ" "${paraviewsdk_extract_dir}"
  LABELS "ParaView\;ParaViewSDK")

set(paraview_source_dir "<SOURCE_DIR>")
_ep_replace_location_tags(paraview paraview_source_dir)

set(paraviewsdk_test_dir "${CMAKE_CURRENT_BINARY_DIR}/paraviewsdk/tests")
function (add_paraviewsdk_example_test name dir)
  add_test(
    NAME    "paraviewsdk-example-${name}"
    COMMAND "${CMAKE_CTEST_COMMAND}"
            --build-and-test
            "${paraview_source_dir}/Examples/${dir}"
            "${paraviewsdk_test_dir}/examples/${name}"
            --build-generator "${CMAKE_GENERATOR}"
            --build-options
            "-DParaView_DIR:PATH=${paraviewsdk_extract_dir}/lib/cmake/paraview-${paraview_version}")
  set_tests_properties("paraviewsdk-example-${name}"
    PROPERTIES
      DEPENDS "extract-paraviewsdk-TGZ"
      LABELS  "ParaView;ParaViewSDK"
      TIMEOUT 1200)
endfunction ()

function (add_paraviewsdk_example_app_test name)
  string(TOLOWER "${name}" lower_name)
  add_paraviewsdk_example_test("app-${lower_name}" "CustomApplications/${name}")
endfunction ()

function (add_paraviewsdk_example_catalyst_test name)
  string(TOLOWER "${name}" lower_name)
  add_paraviewsdk_example_test("catalyst-${lower_name}" "Catalyst/${name}")
endfunction ()

function (add_paraviewsdk_example_plugin_test name)
  string(TOLOWER "${name}" lower_name)
  add_paraviewsdk_example_test("plugin-${lower_name}" "Plugins/${name}")
endfunction ()

set(gui_enabled FALSE)
if (qt5_enabled OR qt6_enabled)
  set(gui_enabled TRUE)
endif ()

if (gui_enabled)
  add_paraviewsdk_example_app_test(Spreadsheet)
  add_paraviewsdk_example_app_test(Clone1)
  add_paraviewsdk_example_app_test(Clone2)
  add_paraviewsdk_example_app_test(Demo0)
  add_paraviewsdk_example_app_test(Demo1)
  add_paraviewsdk_example_app_test(MultiServerClient)
  add_paraviewsdk_example_app_test(ParticlesViewer)
endif ()

if (mpi_enabled)
  add_paraviewsdk_example_catalyst_test(CFullExample)
  add_paraviewsdk_example_catalyst_test(CxxImageDataExample)
  add_paraviewsdk_example_catalyst_test(CxxMappedDataArrayExample)
  add_paraviewsdk_example_catalyst_test(CxxMultiPieceExample)
  add_paraviewsdk_example_catalyst_test(CxxPVSMPipelineExample)
  add_paraviewsdk_example_catalyst_test(MPISubCommunicatorExample)
  add_paraviewsdk_example_catalyst_test(CFullExample2)
  add_paraviewsdk_example_catalyst_test(CxxFullExample)
  add_paraviewsdk_example_catalyst_test(CxxNonOverlappingAMRExample)
  add_paraviewsdk_example_catalyst_test(CxxOverlappingAMRExample)
  add_paraviewsdk_example_catalyst_test(CxxParticlePathExample)
  add_paraviewsdk_example_catalyst_test(CxxSOADataArrayExample)
  add_paraviewsdk_example_catalyst_test(CxxVTKPipelineExample)
  if (NOT CMAKE_GENERATOR MATCHES "Ninja")
    add_paraviewsdk_example_catalyst_test(Fortran90FullExample)
    add_paraviewsdk_example_catalyst_test(FortranPoissonSolver)
  endif ()
  add_paraviewsdk_example_catalyst_test(PythonDolfinExample)
endif ()

if (gui_enabled)
  add_paraviewsdk_example_plugin_test(Autostart)
  add_paraviewsdk_example_plugin_test(RepresentationBehavior)
endif ()
add_paraviewsdk_example_plugin_test(DockWidget)
add_paraviewsdk_example_plugin_test(ElevationFilter)
add_paraviewsdk_example_plugin_test(GUIMyToolBar)
add_paraviewsdk_example_plugin_test(MyPNGReader)
add_paraviewsdk_example_plugin_test(MyTiffWriter)
add_paraviewsdk_example_plugin_test(PropertyWidgets)
add_paraviewsdk_example_plugin_test(ReaderXMLOnly)
add_paraviewsdk_example_plugin_test(SMMyProxy)
add_paraviewsdk_example_plugin_test(SourceToolbar)
if (visitbridge_enabled)
  add_paraviewsdk_example_plugin_test(VisItReader)
endif ()
