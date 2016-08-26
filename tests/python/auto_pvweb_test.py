
import sys, time, re

"""
This script is meant to test full round trip communication to remote
ParaViewWeb servers, including access to static content and launching
of the ParaViewWeb processes.  In order for it to work, the remote end
must have, linked from the top level of its static content directory,
a folder containing the following containing the following index.html
content.

<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body onbeforeunload="stop()" onunload="stop()">

  <!-- Scripts -->
  <script src="../../lib/core/vtkweb-loader.js" load="core"></script>
  <script type="text/Javascript">
    var config = {
      sessionManagerURL: vtkWeb.properties.sessionManagerURL,
      application: "pvw-test"
    },
    connection = null,
    fileList = null;
    var stop = vtkWeb.NoOp;
    var start = function(c) {
      connection = c;

      // Update stop method to use the connection
      stop = function() {
        connection.session.call('application.exit');
      }
    };

    // Try to launch the Viz process
    vtkWeb.smartConnect(config, start, function(code,reason){
      console.log("Inside smartConnect close callback.");
    });
  </script>
</body>
</html>

Note that this index.html content needs access to normal paraview/vtkWeb
static content located in the "lib" and "ext" folders, so the symlink setup
needs to be such that these javascript dependencies can be satisfied.

"""

dependencies_met = True

try:
    import argparse, selenium, requests
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
def simpleProtocolTest(window, pvweb_host, path):
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

    # Execute the list directories and files rpc call
    window.execute_script("connection.session.call('file.server.directory.list').then(function(obj){fileList=obj;},function(err){fileList=err;});")
    time.sleep(5)
    result = window.execute_script("return fileList");

    if not 'dirs' in result or not 'files' in result:
        print 'Got unexpected results from file.server.directory.list rpc method:'
        print result
        return 1

    if len(result['dirs']) == 0 or len(result['files']) == 0:
        print 'Expected non-zero length files and directories list, actually got:'
        print result
        return 1

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
def runPvwebTest(pvweb_host, path, browserName):
    returnStatus = 1

    # Create a chrome window for the test
    if browserName == 'firefox':
        window = webdriver.Firefox()
    else:
        window = webdriver.Chrome()

    window.set_window_size(720, 520)

    # Try to run the actual test
    try:
        returnStatus = simpleProtocolTest(window, pvweb_host, path)
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
def runOnAllHosts(browserName, urlListString):
    regex = re.compile('http://([^/]+)(/.+)')
    urlList = urlListString.split(';')
    result = 0
    for url in urlList:
        m = regex.search(url)
        if m:
            print 'Testing against ' + url
            result += runPvwebTest(m.group(1), m.group(2), browserName)
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
    p.add_argument("-b", "--browser", type=str, default="firefox", help="Should be either 'chrome' or 'firefox'")
    args = p.parse_args()

    sys.exit(runOnAllHosts(args.browser, args.testurls))
