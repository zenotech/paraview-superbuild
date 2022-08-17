import sys
from paraview.apps.visualizer import main

sys.argv.append("--timeout")
sys.argv.append("10")


sys.argv.append("--host")
sys.argv.append("0.0.0.0")

sys.argv.append("--port")
sys.argv.append("9876")  # ideally we want 0 to let the OS pick the port

main()
