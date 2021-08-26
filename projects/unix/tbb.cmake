set(tbb_archdir intel64)
set(tbb_libdir "lib/${tbb_archdir}/gcc4.4")
set(tbb_libsuffix "${CMAKE_SHARED_LIBRARY_SUFFIX}*")
include(tbb.common)
