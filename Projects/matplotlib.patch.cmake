# SOURCE_DIR matplotlib source directory
# PATCHES_DIR superbuild patches directory
# INSTALL_DIR superbuild install prefix
# PATCH_OUTPUT_DIR where to configure patched files into (CMAKE_BINARY_DIR)

# Matplotlib expects these libraries to be named differently on windows...
if(WIN32)
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      "${INSTALL_DIR}/lib/zlib.lib"
      "${INSTALL_DIR}/lib/z.lib"
  )
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      "${INSTALL_DIR}/lib/libpng14.lib"
      "${INSTALL_DIR}/lib/png.lib"
  )
endif()

if (APPLE AND FORCE_C++11)
  # replace hardcoded c++ and libstdc++ with c++11 and libc++
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      "${PATCHES_DIR}/matplotlib.setupext.py"
      "${SOURCE_DIR}/setupext.py"
    )
endif()

configure_file("${PATCHES_DIR}/matplotlib.setup.cfg.in"
  "${PATCH_OUTPUT_DIR}/matplotlib.setup.cfg")

execute_process(COMMAND
    ${CMAKE_COMMAND} -E copy_if_different
    "${PATCH_OUTPUT_DIR}/matplotlib.setup.cfg"
    "${SOURCE_DIR}/setup.cfg"
)
