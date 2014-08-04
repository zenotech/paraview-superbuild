
import sys, time, re

dependencies_met = True

try:
    import argparse, selenium, Image, requests
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
# Checks the version hash which gets written by the update process.
# ============================================================================
def checkInstallHash(url):
    response = requests.get(url + 'hash.json')
    if response.status_code != 200:
        print "Warning, unable to retrieve the installation hash from " + url
    else:
        print "Installation hash info:"
        hashObj = response.json()
        for key in hashObj:
            print "     " + key + " => " + hashObj[key]


# ============================================================================
# Loads the WebVisualizer and interacts with it.
# ============================================================================
def webVisualizerTest(window, pvweb_host, path):
    urlRoot = 'http://' + pvweb_host + '/'
    url = urlRoot + path

    # First do a simple check that makes sure host is up
    checkInstallHash(urlRoot)

    # Fire up the error collector
    window.execute_script(javascript_collect_errors)

    # Load the target web application
    window.get(url)
    time.sleep(15)
    print 'Loaded application'

    # Click on the "Open file" icon to start the process of loading a file
    filesSpan = window.find_element_by_css_selector(".inspector-selector[data-type=files]")
    filesSpan.click()
    time.sleep(3)
    print 'Clicked link to open file'

    # Click on the "can" link to load some paraview data.  We have the
    # expectation here that the paraview data dir with which we started the
    # server points to the "Data" folder in the standard ParaViewData git
    # repo.
    canLi = window.find_element_by_css_selector('li.clickable[data-file="can.ex2"]')
    canLi.click()
    time.sleep(3)
    print 'Clicked link to open the can dataset'

    # Find the representation properties
    reprPanel = window.execute_script("return $('span.vtk-icon-plus-circled:contains(Representation)')[0]")
    try:
        reprPanel.click()
    except:
        try:
            reprPanel.click()
        except:
            print 'Unable to click on the representation panel'
            return 1
    time.sleep(3)
    print 'Clicked to open the representation panel'

    # Click on the select option corresponding to DISPL
    selectElt = window.find_element_by_css_selector('select.form-control.array')
    selectElt.click()
    time.sleep(3)
    print 'Clicked on the ColorBy select widget'

    displOpt = window.find_element_by_css_selector('option[value="ARRAY:POINTS:DISPL"]')
    displOpt.click()
    time.sleep(3)
    print 'Clicked on the DISPL array'

    # Click the refresh button
    refreshButton = window.find_element_by_css_selector('span.clickable[data-action=apply-property-values]')
    refreshButton.click()
    time.sleep(3)
    print 'Clicked the apply button'

    # Toggle time toolbar
    toggleTime = window.find_element_by_css_selector('.toggle-time-toolbar.clickable')
    toggleTime.click()
    time.sleep(3)
    print 'Displayed the time toolbar'

    # Jump to the final time step
    endTimeLi = window.find_element_by_css_selector('span.vcr-action[data-action=last]')
    endTimeLi.click()
    time.sleep(1)
    print 'Clicked button to jump to last timestep'

    # Rescale now that we're at the final time step
    rescaleIcon = window.find_element_by_css_selector('span.clickable[data-action=rescale-data]')
    rescaleIcon.click()
    time.sleep(1)
    print 'Clicked rescale button'

    # Now retrieve any errors we collected during the test
    errors = window.execute_script(javascript_get_errors)

    if errors == None:
        print 'Test sequence completed successfully'
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
# Split up the urls and break them up into their component pieces to run the
# test on each.
# ============================================================================
def runOnAllHosts(urlListString):
    regex = re.compile('http://([^/]+)(/.+)')
    urlList = urlListString.split(';')
    result = 0
    for url in urlList:
        m = regex.search(url)
        if m:
            print 'Testing against ' + url
            result += runPvwebTest(m.group(1), m.group(2))
        else:
            print 'Unknown url format: ' + url
            result += 1
    return result


# ============================================================================
# Main script entry point
# ============================================================================
if __name__ == "__main__":
    if dependencies_met == False:
        # TODO: use the CMake feature SKIP_RETURN_CODE in the future
        print 'Some python module dependency was unmet, allow test pass'
        sys.exit(0)

    p = argparse.ArgumentParser(description="Test remote ParaViewWeb instances")
    p.add_argument("-t", "--testurls", type=str, default="", help="List of urls to test")
    args = p.parse_args()

    sys.exit(runOnAllHosts(args.testurls))
