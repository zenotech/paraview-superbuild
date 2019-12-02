set(nvidiamdl_libdir nt-x86-64/lib)
set(nvidiamdl_libdest bin)

include(nvidiamdl.common)

superbuild_add_extra_cmake_args(
  -Ddds_LIBRARY:FILEPATH=<INSTALL_DIR>/bin/dds.dll
  -Dlibmdl_sdk_LIBRARY:FILEPATH=<INSTALL_DIR>/bin/libmdl_sdk.dll
  -Dnv_freeimage_LIBRARY:FILEPATH=<INSTALL_DIR>/bin/nv_freeimage.dll)
