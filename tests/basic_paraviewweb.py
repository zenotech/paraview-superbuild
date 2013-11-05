from paraview.web import wamp, protocols, pv_web_visualizer
from vtk.web import server

# Configure our current application
pv_web_visualizer._PipelineManager.authKey = 'paraviewweb-secret'
pv_web_visualizer._PipelineManager.dataDir = '.'

# Setup static args
class TestArgs:
    pass

args = TestArgs()
args.port    = 8081
args.debug   = 1
args.timeout = 10
args.content = ''
args.nosignalhandlers = False

# Start server
server.start_webserver(options=args, protocol=pv_web_visualizer._PipelineManager)
