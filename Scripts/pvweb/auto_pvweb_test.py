
import sys, time

dependencies_met = True

try:
    import argparse, selenium, Image
    from selenium import webdriver
except Exception as inst:
    print "Unable to import needed modules:"
    print inst
    dependencies_met = False


# ============================================================================
# Following are a couple of bits of Javascript selenium can execute for us
# so we can keep track of any errors that might have showed up in the console,
# but which we can't otherwise see because we're using selenium.
# ============================================================================
javascript_collect_errors = \
"window.onerror = function(m,u,l) {" + \
"  if (!window.pvwebTestErrors) {" + \
"    window.pvwebTestErrors = new Array();" + \
"  }" + \
"  window.pvwebTestErrors.push({message: m, url: u, line: l});" + \
"};"

javascript_get_errors = "return window.pvwebTestErrors"


# ============================================================================
# Loads the WebVisualizer and interacts with it.
# ============================================================================
def webVisualizerTest(window, pvweb_host, path):
    url = 'http://' + pvweb_host + '/' + path

    # Fire up the error collector
    window.execute_script(javascript_collect_errors)

    # Load the target web application
    window.get(url)
    time.sleep(10)

    # Click on the "Open file" icon to start the process of loading a file
    filesDiv = window.find_element_by_css_selector(".action.files")
    filesDiv.click()
    time.sleep(3)

    # Click on the "can" link to load some paraview data.  We have the
    # expectation here that the paraview data dir with which we started the
    # server points to the "Data" folder in the standard ParaViewData git
    # repo.
    canLi = window.execute_script("return $('.vtk-files.action:contains(can.ex2)')[0]")
    canLi.click()
    time.sleep(3)

    # Now choose how to color the object
    colorByLink = window.find_element_by_css_selector(".colorBy.color")
    colorByLink.click()
    time.sleep(1)

    colorByDispLi = window.find_element_by_css_selector(".points[name=DISPL]")
    colorByDispLi.click()
    time.sleep(1)

    # Jump to the final time step
    endTimeLi = window.find_element_by_css_selector(".action[action=last]")
    endTimeLi.click()
    time.sleep(1)

    # Rescale now that we're at the final time step
    rescaleIcon = window.find_element_by_css_selector(".rescale-data")
    rescaleIcon.click()
    time.sleep(1)

    # Now click the resetCamera icon so that we change the center of
    # rotation
    resetCameraIcon = window.find_element_by_css_selector("[action=resetCamera]");
    resetCameraIcon.click()
    time.sleep(1)

    # Now retrieve any errors we collected during the test
    errors = window.execute_script(javascript_get_errors)

    if errors == None:
        return 0
    else:
        print "Here are the errors we collected during the run:"
        print errors
        return 1


# ============================================================================
# Just wraps the actual test in a try/catch and returns "not ok" in case of an
# exception.
# ============================================================================
def runPvwebTest(pvweb_host, path):
    returnStatus = 1

    # Create a chrome window for the test
    window = webdriver.Chrome()
    window.set_window_size(720, 520)

    # Try to run the actual test
    try:
        returnStatus = webVisualizerTest(window, pvweb_host, path)
    except Exception as inst:
        print 'Caught exception running test:'
        print inst

    # Try to close the window whether there was an exception or not
    try:
        window.quit()
    except:
        print 'Unable to close window, but perhaps it never opened'

    return returnStatus


# ============================================================================
# Main script entry point
# ============================================================================
if __name__ == "__main__":
    if dependencies_met == False:
        # TODO: use the CMake feature SKIP_RETURN_CODE in the future
        print 'Some python module dependency was unmet, allow test pass'
        sys.exit(0)

    p = argparse.ArgumentParser(description="Test remote ParaViewWeb instance")
    p.add_argument("-r", "--remotehost", type=str, default="", help="URL for remote host")
    p.add_argument("-p", "--visualizerpath", type=str, default="", help="Path to application")
    args = p.parse_args()

    sys.exit(runPvwebTest(args.remotehost, args.visualizerpath))
