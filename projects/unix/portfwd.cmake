# portfwd needs automake1.4. So ensure that it's present.
superbuild_add_project(portfwd
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      # Since portfwd puts the executable in "sbin", we change it to put it in
      # bin.
      --sbindir=<INSTALL_DIR>/bin
  BUILD_IN_SOURCE 1)
