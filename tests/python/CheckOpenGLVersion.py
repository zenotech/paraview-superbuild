from __future__ import print_function
import sys
from paraview.modules.vtkPVClientServerCoreRendering import vtkPVOpenGLInformation

if len(sys.argv) == 1:
    print("Usage: %s [strings to match]" % sys.argv[0])
    print("       `strings` are string to match in either OpenGL version, vendor or renderer\n")

info = vtkPVOpenGLInformation()
info.CopyFromObject(None)
print("\nOpenGL Information:")
print("Vendor:", info.GetVendor())
print("Version:", info.GetVersion())
print("Renderer:", info.GetRenderer())

lvendor = info.GetVendor().lower()
lversion = info.GetVersion().lower()
lrenderer = info.GetRenderer().lower()

for arg in sys.argv[1:]:
    larg = arg.lower()
    if larg not in lvendor and \
       larg not in lversion and \
       larg not in lrenderer:
        raise RuntimeError("Failed for find `%s`!" % arg)
