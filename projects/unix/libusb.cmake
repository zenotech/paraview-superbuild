superbuild_add_project(libusb
  LICENSE_FILES
    COPYING
    AUTHORS
  SPDX_LICENSE_IDENTIFIER
    LGPL-2.1-or-later
  SPDX_COPYRIGHT_TEXT
    "Copyright © 2001 Johannes Erdfelt"
    "Copyright © 2007-2009 Daniel Drake"
    "Copyright © 2010-2012 Peter Stuge"
    "Copyright © 2008-2016 Nathan Hjelm"
    "Copyright © 2009-2013 Pete Batard"
    "Copyright © 2009-2013 Ludovic Rousseau"
    "Copyright © 2010-2012 Michael Plante"
    "Copyright © 2011-2013 Hans de Goede"
    "Copyright © 2012-2013 Martin Pieuchot"
    "Copyright © 2012-2013 Toby Gray"
    "Copyright © 2013-2018 Chris Dickens"
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
