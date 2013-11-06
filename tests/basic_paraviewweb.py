from paraview.web import wamp, protocols, pv_web_visualizer
from vtk.web import server

# Configure our current application
pv_web_visualizer._PipelineManager.authKey = 'paraviewweb-secret'
pv_web_visualizer._PipelineManager.dataDir = '.'

# Setup static args
class TestArgs:
    pass

args = TestArgs()
args.host    = 'localhost'
args.port    = 8081
args.debug   = 1
args.timeout = 10
args.content = ''
args.nosignalhandlers = False
args.authKey = 'vtkweb-secret'
args.forceFlush = False
args.testScriptPath = ''
args.baselineImgDir = ''
args.path = '.'
args.file = None
args.dsHost = None
args.dsPort = 11111
args.rsHost = None
args.rsPort = 11111

# Start server
server.start_webserver(options=args, protocol=pv_web_visualizer._PipelineManager)
