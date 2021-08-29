set(matplotlib_args)
if (WIN32)
  set(matplotlib_args
    CONFIGURE_COMMAND
      "${CMAKE_COMMAND}"
      "-Dinstall_location=<INSTALL_DIR>"
      "-Dskip_configure=TRUE"
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/matplotlib.patch.cmake"

    PROCESS_ENVIRONMENT
      CL "/I<INSTALL_DIR>/include"
      LINK "/LIBPATH:<INSTALL_DIR>/lib")
endif()

set(matplotlib_depends)
if (APPLE)
  list(APPEND matplotlib_depends
    pkgconf)

  if (pkgconf_enabled)
    list(APPEND matplotlib_process_environment
      PKG_CONFIG "${superbuild_pkgconf}")
  endif ()
endif ()

superbuild_add_project_python(matplotlib
  PACKAGE matplotlib
  DEPENDS numpy png freetype zlib pythondateutil pytz pythonpyparsing pythoncycler pythonsetuptools cxx11 pythonkiwisolver
          ${matplotlib_depends}
  PROCESS_ENVIRONMENT
    "${matplotlib_process_environment}"
  ${matplotlib_args})
superbuild_apply_patch(matplotlib nostatic
  "Disable static builds")
superbuild_apply_patch(matplotlib no-jquery
  "Disable jquery download")
