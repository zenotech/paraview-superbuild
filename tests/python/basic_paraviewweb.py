from paraview.web import wamp, protocols, pv_web_visualizer
from vtk.web import server

# Configure our current application
pv_web_visualizer._VisualizerServer.authKey = 'paraviewweb-secret'
pv_web_visualizer._VisualizerServer.dataDir = '.'

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
# Start server
server.start_webserver(options=args, protocol=pv_web_visualizer._VisualizerServer)
