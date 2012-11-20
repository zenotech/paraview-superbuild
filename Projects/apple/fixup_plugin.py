#!/usr/bin/env python

# Arguments for this script are

import commands
import sys
import os.path
import re
import shutil
from fixup_bundle import *

plugin_dir = sys.argv[1]

prefix_map = {}
for arg in sys.argv[2:]:
  key, value = arg.split("=")
  prefix_map[key] = value

libs_to_fix = commands.getoutput('find %s -type f | xargs file --separator ":--:" | grep -i ":--:.*Mach-O" | sed "s/:.*//" | sort | uniq ' % plugin_dir).split()
print "Found", len(libs_to_fix), "libraries to fix."
print "\n".join(libs_to_fix)
print ""

for plugin_lib in libs_to_fix:
  commands.getoutput('chmod u+w "%s"' % plugin_lib)
  # find all libraries the plugin depends on.
  external_libraries = commands.getoutput(
    'find %s | xargs file | grep "Mach-O" | sed "s/:.*//" | xargs otool -l | grep " name" | sort | uniq | sed "s/name\ //" | grep -v "@" | sed "s/ (offset.*)//"' % plugin_lib).split()
  for elib in external_libraries:
    if not isexcluded(elib):
      # for each lib that the plugin depends on, we check if the prefix for the name
      # matches one of the arguments passed to the script. If so, we can fix
      # the reference.
      elibObj = Library.createFromReference(elib, plugin_dir)
      for key in prefix_map.keys():
        if re.match(r'^%s/.*' % key, elibObj.Id):
          oldid = elibObj.Id
          elibObj.copyToApp(None, True)
          commands.getoutput("install_name_tool -change %s %s %s" % (oldid, elibObj.Id, plugin_lib))
          break
  commands.getoutput('chmod a-w "%s"' % plugin_lib)
