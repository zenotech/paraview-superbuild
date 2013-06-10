from paraview import web, paraviewweb_wamp, paraviewweb_protocols
from paraview import pipeline_manager

# Configure our current application
pipeline_manager._PipelineManager.authKey = 'paraviewweb-secret'
pipeline_manager._PipelineManager.dataDir = '.'

# Setup static args
class TestArgs:
    pass

args = TestArgs()
args.port    = 8081
args.debug   = 1
args.timeout = 10
args.content = ''

# Start server
web.start_webserver(options=args, protocol=pipeline_manager._PipelineManager)
