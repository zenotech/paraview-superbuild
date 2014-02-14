add_external_project(mesa
  CONFIGURE_COMMAND
    echo "no configure"
  BUILD_COMMAND
    make ${cross_target}
  INSTALL_COMMAND
    make install
  BUILD_IN_SOURCE 1
)

set(OSMESA_CONFIG_FILE "${SuperBuild_CMAKE_DIR}/crosscompile/${cross_target}/osmesa_config")
string(TOLOWER "${CROSS_BUILD_SITE}" lsite)
if (EXISTS "${CMAKE_SOURCE_DIR}/CMake/crosscompile/${cross_target}/osmesa_config.${lsite}" )
   set(OSMESA_CONFIG_FILE "${SuperBuild_CMAKE_DIR}/crosscompile/${cross_target}/osmesa_config.${lsite}")
endif()

add_external_project_step(patch1
    COMMENT "Patching Mesa for cross-compilation."
    COMMAND sh "${SuperBuild_CMAKE_DIR}/crosscompile/prep_mesa_cross.sh" "<SOURCE_DIR>" "${OSMESA_CONFIG_FILE}" "${cross_target}" "<INSTALL_DIR>"
    DEPENDEES update
    DEPENDERS patch)

conditionally_patch_for_crosscompilation(Mesa "" 1 1)
