set (qt_depends)
set (qt_options)
set (patch_command)
if (NOT APPLE AND UNIX)
  list (APPEND qt_depends freetype fontconfig png)
  list (APPEND qt_options
               -system-libpng
               -I <INSTALL_DIR>/include/freetype2
               -I <INSTALL_DIR>/include/fontconfig)
elseif (APPLE)
  list (APPEND qt_options
              -sdk ${CMAKE_OSX_SYSROOT}
              -arch ${CMAKE_OSX_ARCHITECTURES})
  # Need to patch Qt code to build with Xcode 4.3 or newer (where SDK
  # location chnages using the following command:
  #find . -name "*.pro" -exec sed -i -e "s:/Developer/SDKs/:.*:g" {} \;
  set (patch_command
       PATCH_COMMAND /usr/bin/find . -name "*.pro" -exec sed -i -e "s:/Developer/SDKs/:.*:g" {} +)
endif()
set(qt_EXTRA_CONFIGURATION_OPTIONS ""
    CACHE STRING "Extra arguments to be passed to Qt when configuring.")

add_external_project_or_use_system(
    qt
    DEPENDS zlib ${qt_depends}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
                      -prefix <INSTALL_DIR>
                      -confirm-license
                      -release
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
                      ${qt_EXTRA_CONFIGURATION_OPTIONS}
    PROCESS_ENVIRONMENT
      LD_LIBRARY_PATH "<BINARY_DIR>/lib"
    ${patch_command}
)
