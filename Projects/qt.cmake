add_external_project_or_use_system(
    qt
    DEPENDS zlib png freetype fontconfig
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
                      -prefix <INSTALL_DIR>
                      -confirm-license
                      -no-audio-backend
                      -no-dbus
                      -nomake demos
                      -nomake examples
                      -no-multimedia
                      -no-openssl
                      -no-phonon
                      -no-xinerama
                      -no-script
                      -no-scripttools
                      -no-declarative-debug
                      -no-xvideo
                      -opensource
                      -qt-libjpeg
                      -qt-libtiff
                      -system-libpng
                      -system-zlib
                      -webkit
                      -xmlpatterns
                      -I <INSTALL_DIR>/include
                      -I <INSTALL_DIR>/include/freetype2
                      -I <INSTALL_DIR>/include/fontconfig
                      -L <INSTALL_DIR>/lib
    PROCESS_ENVIRONMENT
      LD_LIBRARY_PATH "<BINARY_DIR>/lib"
)
