from paraview import web, paraviewweb_wamp, paraviewweb_protocols
from paraview.pipeline_manager import *

# Configure our current application
PipelineManager.authKey = 'paraviewweb-secret'
PipelineManager.dataDir = '.'

# Setup static args
class TestArgs:
    pass

args = TestArgs()
args.port    = 8081
args.debug   = 1
args.timeout = 10
args.content = ''

# Start server
web.start_webserver(options=args, protocol=PipelineManager)
