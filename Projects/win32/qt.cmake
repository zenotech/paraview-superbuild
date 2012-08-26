# fix the zdll.lib issue (qt wants the library to be named differently hence
# skipping using our zlib on windows. Let qt build its own zlib.)
add_external_project_or_use_system(
  qt
  DEPENDS zlib
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    -prefix <INSTALL_DIR>
                    -confirm-license
                    -opensource
                    -release
                    -no-audio-backend
                    -no-dbus
                    -no-declarative-debug
                    -no-multimedia
                    -no-openssl
                    -no-phonon
                    -no-script
                    -no-scripttools
                    -nomake demos
                    -nomake examples
                    -qt-libjpeg
                    -qt-libtiff
                    -webkit
                    -xmlpatterns
                    -I <INSTALL_DIR>/include
                    -L <INSTALL_DIR>/lib
  # nmake will already be in path for VS-devenv or nmake environments
  # so we don't have to provide full paths.
  BUILD_COMMAND     nmake
  INSTALL_COMMAND   nmake install
) 
