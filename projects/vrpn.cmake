superbuild_add_project(vrpn
  CMAKE_ARGS
    # GPM support is enabled if GPM is found on the machine. This later ends up
    # complaining that it is GPL stuff and needs another flag to work. We never
    # want this, so just always disable it.
    -DVRPN_USE_GPM_MOUSE:BOOL=OFF
    # We want the new parser; without this, some FindJava syntax errors pop up
    # with newer CMake binaries. This is easier than a patch.
    -DCMAKE_POLICY_DEFAULT_CMP0053:STRING=NEW
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS})

# Backported from upstream commit 70d47fec7e3be85f5f05c8ac5be99dacbd8be257.
superbuild_apply_patch(vrpn wait3-removal
  "Remove wait3 usage")
