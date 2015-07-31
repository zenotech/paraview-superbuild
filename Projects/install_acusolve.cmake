if (APPLE)
  set (SHARED_LIBRARY_PREFIX "lib")
  set (SHARED_LIBRARY_SUFFIX ".dylib")
elseif (UNIX)
  set (SHARED_LIBRARY_PREFIX "lib")
  set (SHARED_LIBRARY_SUFFIX ".so")
elseif (WIN32)
  set (SHARED_LIBRARY_PREFIX "")
  set (SHARED_LIBRARY_SUFFIX ".dll")
endif()

set(plugin_dir "${TMP_DIR}/AcuSolveReaderPlugin-${bundle_suffix}")

# Remove any old directory
file(REMOVE_RECURSE "${plugin_dir}")
# Create a directory to put the plugin under.
file(MAKE_DIRECTORY "${plugin_dir}")

# Copy the plugin lib.
file(COPY "${BINARY_DIR}/${SHARED_LIBRARY_PREFIX}AcuSolveReader${SHARED_LIBRARY_SUFFIX}"
  DESTINATION "${plugin_dir}")

if (APPLE)
  execute_process(
    COMMAND ${CMAKE_CURRENT_LIST_DIR}/apple/fixup_plugin.py
            # The directory containing the plugin dylibs.
            "${plugin_dir}"
            # names to replace (in order)
            "${PARAVIEW_BINARY_DIR}/lib/=@executable_path/../Libraries/"
            "${INSTALL_DIR}/lib/Qt=@executable_path/../Frameworks/Qt"
            "${INSTALL_DIR}/lib/=@executable_path/../Libraries/"
            "libhdf5.7.3.0.dylib=@executable_path/../Libraries/libhdf5.1.8.9.dylib"
            "libhdf5_hl.7.3.0.dylib=@executable_path/../Libraries/libhdf5.1.8.9.dylib"
            "libcgns.3.1.dylib=@executable_path/../Libraries/libcgns.3.1.dylib"
            )
endif()

# make tarball
include("${PLUGIN_SCRIPT}")
make_plugin_tarball("${TMP_DIR}"
  "${bundle_name}-${bundle_suffix}"
  "AcuSolveReaderPlugin-${bundle_suffix}")
