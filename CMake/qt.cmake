ExternalProject_Add(
  qt
  PREFIX qt
  DEPENDS zlib png freetype fontconfig
  URL "ftp://ftp.qt.nokia.com/qt/source/qt-everywhere-opensource-src-4.6.4.tar.gz"
  URL_MD5 8ac880cc07a130c39607b65efd5e1421
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/downloads
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    -prefix ${internal_install_root}
                    -no-dbus
                    -no-javascript-jit
                    -no-openssl
                    -no-script
                    -no-scripttools
                    -no-xinerama
                    -no-phonon
                    -no-multimedia
                    -no-audio-backend
                    -opensource
                    -system-libpng
                    -system-zlib
                    -qt-libjpeg
                    -qt-libtiff
                    -webkit
                    -xmlpatterns
                    -I ${internal_install_root}/include
                    -I ${internal_install_root}/include/freetype2
                    -I ${internal_install_root}/include/fontconfig
                    -L ${internal_install_root}/lib
)
