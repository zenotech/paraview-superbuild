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

# Remove any old directory
execute_process(COMMAND ${CMAKE_COMMAND} -E remove_directory ${TMP_DIR}/AcuSolveReaderPlugin-${bundle_suffix}
  WORKING_DIRECTORY ${TMP_DIR}
)

# Create a directory to put the plugin under.
execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${TMP_DIR}/AcuSolveReaderPlugin-${bundle_suffix}
  WORKING_DIRECTORY ${TMP_DIR}
)

# Copy th plugin lib.
execute_process(COMMAND ${CMAKE_COMMAND} -E copy ${BINARY_DIR}/${SHARED_LIBRARY_PREFIX}AcuSolveReader${SHARED_LIBRARY_SUFFIX} ${TMP_DIR}/AcuSolveReaderPlugin-${bundle_suffix}
  WORKING_DIRECTORY ${TMP_DIR}
)

if (APPLE)
  execute_process(
    COMMAND ${CMAKE_CURRENT_LIST_DIR}/apple/fixup_plugin.py
            # The directory containing the plugin dylibs.
            ${TMP_DIR}/AcuSolveReaderPlugin-${bundle_suffix}
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
execute_process(
  COMMAND ${CMAKE_COMMAND}
  -E tar cvfz ${bundle_name}-${bundle_suffix}.tgz AcuSolveReaderPlugin-${bundle_suffix}
  WORKING_DIRECTORY ${TMP_DIR})
