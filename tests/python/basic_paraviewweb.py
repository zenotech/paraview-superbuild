from paraview.web import test_server
from wslink import server

# Configure our current application
test_server._TestServer.authKey = 'paraviewweb-secret'
test_server._TestServer.dataDir = '.'

# Setup static args
class TestArgs:
    pass

args = TestArgs()
args.host    = 'localhost'
args.port    = 8081
args.debug   = True
args.timeout = 10
args.content = ''
args.nosignalhandlers = False
args.authKey = 'vtkweb-secret'
args.forceFlush = False
args.testScriptPath = ''
args.baselineImgDir = ''
args.uploadPath = None
args.path = '.'
args.file = None
args.dsHost = None
args.dsPort = 11111
args.rsHost = None
args.rsPort = 11111
args.rcPort = -1
args.plugins = ""
args.exclude = "^\\.|~$|^\\$"
args.group = "[0-9]+\\."
args.palettes = None
args.proxies = None
args.no_auto_readers = False
args.sslKey = None
args.sslCert = None
args.ws = 'ws'
args.lp = 'lp'
args.nows = False
args.nolp = False
args.nobws = False
args.fsEndpoints = ''
# Start server
server.start_webserver(options=args, protocol=test_server._TestServer)
