set(PARAVIEW_WEB_REMOTE_URLS
  http://pvw-test.kitware.com/sbtest
  http://pvw.kitware.com/sbtest
  http://paraviewweb.kitware.com/sbtest
  CACHE STRING "A list of urls against which to run a simple Web Visualizer test.")
set(PARAVIEW_WEB_BROWSER firefox
  CACHE STRING "Which browser to use during testing, either chrome or firefox")
set_properties(CACHE PARAVIEW_WEB_BROWSER
  PROPERTY
    STRINGS firefox chrome)
mark_as_advanced(PARAVIEW_WEB_REMOTE_URLS PARAVIEW_WEB_BROWSER)

#------------------------------------------------------------------------------
# Simple test of a public, automatically deployed version of paraviewweb.  If
# system python does not have selenium, test will still be added and run, but
# will be allowed to pass only in the case of missing python modules.
# TODO: In the future we can set here a SKIP_RETURN_CODE to allow the test to
# return a value which will indicate to CTest that some dependencies were not
# met.
find_package(PythonInterp 2.7)
if (PYTHON_EXECUTABLE)
  add_test(
    NAME    paraview-web-autodeploy
    COMMAND "${PYTHON_EXECUTABLE}"
            "${CMAKE_CURRENT_SOURCE_DIR}/../Scripts/pvweb/auto_pvweb_test.py"
            "--testurls=${PARAVIEW_WEB_REMOTE_URLS}"
            "--browser=${PARAVIEW_WEB_BROWSER}")
  set_tests_properties(paraview-web-autodeploy
    PROPERTIES
      LABELS "PARAVIEW")
endif ()
