set(qt5_SKIP_PCH "ON" CACHE BOOL "")

if ("$ENV{CI_JOB_NAME}" MATCHES "windows")
  set(CMAKE_C_COMPILER_LAUNCHER "buildcache" CACHE STRING "")
  set(CMAKE_CXX_COMPILER_LAUNCHER "buildcache" CACHE STRING "")
  set(superbuild_replace_uncacheable_flags ON CACHE BOOL "")
# Linux replaces `CC` and `CXX`
elseif (NOT "$ENV{CI_JOB_NAME}" MATCHES "linux")
  set(CMAKE_C_COMPILER_LAUNCHER "sccache" CACHE STRING "")
  set(CMAKE_CXX_COMPILER_LAUNCHER "sccache" CACHE STRING "")
endif ()
