macro (paraview_superbuild_add_pdf name outname)
  superbuild_add_project("${name}"
    NO_EXTRACT 1
    CONFIGURE_COMMAND
      ""
    BUILD_COMMAND
      ""
    INSTALL_COMMAND
      "${CMAKE_COMMAND}" -E copy_if_different
        <DOWNLOADED_FILE>
        "<INSTALL_DIR>/doc/${outname}")

  if (${name}_enabled)
    set("${name}_pdf" "${superbuild_install_location}/doc/${outname}")
  endif ()
endmacro ()
