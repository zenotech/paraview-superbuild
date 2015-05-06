# fix the zdll.lib issue (qt wants the library to be named differently hence
# skipping using our zlib on windows. Let qt build its own zlib.)
add_external_project_or_use_system(
  qt
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND <SOURCE_DIR>/configure.exe
                    -prefix <INSTALL_DIR>
                    -confirm-license
                    -no-audio-backend
                    -no-dbus
                    -no-declarative-debug
                    -nomake demos
                    -nomake examples
                    -nomake tests
                    -no-multimedia
                    -no-openssl
                    -no-phonon
                    -no-script
                    -no-scripttools
                    -no-webkit
                    -opensource
                    -qt-libjpeg
                    -qt-libtiff
                    -release
                    -xmlpatterns
                    -I <INSTALL_DIR>/include
                    -L <INSTALL_DIR>/lib
  BUILD_COMMAND     ${NMAKE_PATH} 
  INSTALL_COMMAND   ${NMAKE_PATH} install
) 
