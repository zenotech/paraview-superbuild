add_external_dummy_project(paraviewsdk DEPENDS paraview)
if (paraviewsdk_ENABLED)
  # install all include files.
  install(DIRECTORY "${install_location}/include/"
          DESTINATION "include"
          COMPONENT superbuild)

  # install all library files (including those for dependencies built).
  install(DIRECTORY "${install_location}/lib/"
          DESTINATION "lib"
          COMPONENT superbuild
          PATTERN "paraview-${pv_version}" EXCLUDE)

  # Workaround to patch any hard-coded paths to the build folder
  install(CODE "
  file(GLOB_RECURSE ALL_CMAKE_FILES \"${install_location}/lib/*.cmake\")
  foreach(F \${ALL_CMAKE_FILES})
    execute_process(
      COMMAND sed \"s|${install_location}|\\\${_IMPORT_PREFIX}|g\" -i \${F}
    )
  endforeach()")

  # install all CMake files.
  install(DIRECTORY "${install_location}/lib/cmake/"
          DESTINATION "lib/cmake"
          COMPONENT superbuild)

  # install all executables since these include the wrapping tools and others.
  install(DIRECTORY "${install_location}/bin/"
          DESTINATION "bin"
          USE_SOURCE_PERMISSIONS
          COMPONENT superbuild)
endif()
