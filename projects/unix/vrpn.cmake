superbuild_add_project(vrpn
  CMAKE_ARGS
    # GPM support is enabled if GPM is found on the machine. This later ends up
    # complaining that it is GPL stuff and needs another flag to work. We never
    # want this, so just always disable it.
    -DVRPN_USE_GPM_MOUSE:BOOL=OFF
    # We want the new parser; without this, some FindJava syntax errors pop up
    # with newer CMake binaries. This is easier than a patch.
    -DCMAKE_POLICY_DEFAULT_CMP0053:STRING=NEW
    -DBUILD_SHARED_LIBS:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    -DPYTHON_ENABLE_MODULE_vrpn-python:BOOL=OFF
    -DVRPN_BUILD_JAVA:BOOL=OFF
    -DVRPN_BUILD_PYTHON_HANDCODED_2X:BOOL=OFF
    -DVRPN_BUILD_PYTHON_HANDCODED_3X:BOOL=OFF
    -DVRPN_BUILD_TEST_RPC_GENERATION:BOOL=OFF
    )
