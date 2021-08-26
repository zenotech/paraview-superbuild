set(tbb_archdir intel64)

if (NOT MSVC_VERSION VERSION_GREATER 1700)
  message(FATAL_ERROR "At least Visual Studio 12.0 (2013) is required")
elseif (NOT MSVC_VERSION VERSION_GREATER 1800)
  set(tbb_vsdir vc12)
elseif (NOT MSVC_VERSION VERSION_GREATER 1999) # 1900 (VS 2015), 191. (VS 2017)
  set(tbb_vsdir vc14)
elseif (tbb_enabled)
  message(FATAL_ERROR "tbb does not support your Visual Studio compiler; please use a system version.")
endif ()

set(tbb_libdir lib/${tbb_archdir}/${tbb_vsdir})
include(tbb.common)
