superbuild_add_project(libusb
  LICENSE_FILES
    COPYING
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --enable-examples-build=no
      --enable-tests-build=no
      --enable-udev=no
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    $(MAKE) install
  BUILD_IN_SOURCE 1)
