add_external_project(
  qt
  DEPENDS zlib png freetype fontconfig
  URL "ftp://ftp.qt.nokia.com/qt/source/qt-everywhere-opensource-src-4.6.4.tar.gz"
  URL_MD5 8ac880cc07a130c39607b65efd5e1421
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
)
