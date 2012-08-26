add_external_project_or_use_system(
  qt
  DEPENDS zlib
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix <INSTALL_DIR>
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
                    -system-zlib
                    -webkit
                    -xmlpatterns
                    -I <INSTALL_DIR>/include
                    -L <INSTALL_DIR>/lib
) 
