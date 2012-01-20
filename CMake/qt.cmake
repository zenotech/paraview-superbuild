ExternalProject_Add(
  qt
  PREFIX qt
  DEPENDS zlib png freetype fontconfig
  URL "ftp://ftp.qt.nokia.com/qt/source/qt-everywhere-opensource-src-4.6.4.tar.gz"
  URL_MD5 8ac880cc07a130c39607b65efd5e1421
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/downloads
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    -prefix ${internal_install_root}
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
                    -I ${internal_install_root}/include
                    -I ${internal_install_root}/include/freetype2
                    -I ${internal_install_root}/include/fontconfig
                    -L ${internal_install_root}/lib
)
