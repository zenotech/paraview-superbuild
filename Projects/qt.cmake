set (qt_depends)
set (qt_options)
if (NOT APPLE AND UNIX)
  list (APPEND qt_depends freetype fontconfig png)
  list (APPEND qt_options
               -system-libpng
               -I <INSTALL_DIR>/include/freetype2
               -I <INSTALL_DIR>/include/fontconfig)
endif()
add_external_project_or_use_system(
    qt
    DEPENDS zlib ${qt_depends}
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
                      -system-zlib
                      -webkit
                      -xmlpatterns
                      -I <INSTALL_DIR>/include
                      -L <INSTALL_DIR>/lib
                      ${qt_options}
    PROCESS_ENVIRONMENT
      LD_LIBRARY_PATH "<BINARY_DIR>/lib"
)
