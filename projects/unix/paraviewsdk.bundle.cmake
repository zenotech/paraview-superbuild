# Install all include files.
install(
  DIRECTORY   "${superbuild_install_location}/include/"
  DESTINATION "include"
  COMPONENT   ParaView)

# Install all library files (including those for dependencies built).
install(
  DIRECTORY   "${superbuild_install_location}/lib/"
  DESTINATION "lib"
  COMPONENT   ParaView
  PATTERN     "paraview-${paraview_version}" EXCLUDE)

  # Workaround to patch any hard-coded paths to the build folder
  install(CODE "
    file(GLOB_RECURSE cmake_files \"${superbuild_install_location}/lib/*.cmake\")
    foreach(cmake_file IN LISTS cmake_files)
      execute_process(
        COMMAND sed
                -i
                -e \"s|${superbuild_install_location}|\\\${_IMPORT_PREFIX}|g\"
                \${cmake_file})
    endforeach ()")

  # Install all CMake files.
  install(
    DIRECTORY   "${superbuild_install_location}/lib/cmake/"
    DESTINATION "lib/cmake"
    COMPONENT   ParaView)

  # Install all executables since these include the wrapping tools and others.
  install(
    DIRECTORY   "${superbuild_install_location}/bin/"
    DESTINATION "bin"
    COMPONENT   ParaView
    USE_SOURCE_PERMISSIONS)
endif ()
