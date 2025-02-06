# The `curl` build shadows the system `libcurl`. In an SSL-less build, this
# makes internal `git` usage unable to talk to `https` URLs.
set(PASS_LD_LIBRARY_PATH_FOR_BUILDS OFF CACHE BOOL "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_common.cmake")
