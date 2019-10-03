superbuild_add_project(vrpn
  CMAKE_ARGS
    # GPM support is enabled if GPM is found on the machine. This later ends up
    # complaining that it is GPL stuff and needs another flag to work. We never
    # want this, so just always disable it.
    -DVRPN_USE_GPM_MOUSE:BOOL=OFF
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS})
