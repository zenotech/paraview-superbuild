# portfwd needs automake1.4. So ensure that it's present.
add_external_project(portfwd
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                   # since portfwd puts the executable in "sbin", we change it
                   # to put it in bin.
                    --sbindir=<INSTALL_DIR>/bin
  BUILD_IN_SOURCE 1
)

if (portfwd_ENABLED)
  # install portfwd executable.
  install(PROGRAMS "@install_location@/bin/portfwd"
          DESTINATION "bin"
          COMPONENT superbuild)
endif()
