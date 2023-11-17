superbuild_add_project(socat
  LICENSE_FILES
    COPYING # This is the GPL
  SPDX_LICENSE_IDENTIFIER
    GPL-2.0-or-later
  SPDX_COPYRIGHT_TEXT
    "Copyright Gerhard Rieger and contributors"
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --disable-libwrap
      --disable-openssl
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    $(MAKE) install
  BUILD_IN_SOURCE 1)

superbuild_apply_patch(socat add-missing-stddef
  "Add a missing include for stddef.h")
