set(nvidiaoptix_libdir lib64)
set(nvidiaoptix_libdest lib)
set(nvidiaoptix_libsuffix .lib)
set(nvidiaoptix_bindir bin64)
set(nvidiaoptix_bindest bin)
set(nvidiaoptix_binsuffix .dll)

include(nvidiaoptix.common)

superbuild_add_extra_cmake_args(
  -Doptix_DLL:FILEPATH=<INSTALL_DIR>/bin/optix.6.0.0.dll
  -Doptix_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/optix.6.0.0.lib
  -Doptix_prime_DLL:FILEPATH=<INSTALL_DIR>/bin/optix_prime.6.0.0.dll
  -Doptix_prime_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/optix_prime.6.0.0.lib
  -Doptixu_DLL:FILEPATH=<INSTALL_DIR>/bin/optixu.6.0.0.dll
  -Doptixu_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/optixu.6.0.0.lib)
