set (qt_depends)
set (qt_options)
set (patch_command)
if (NOT APPLE AND UNIX)
  list (APPEND qt_depends freetype fontconfig png)
  list (APPEND qt_options
               -system-libpng
               -I <INSTALL_DIR>/include/freetype2
               -I <INSTALL_DIR>/include/fontconfig)
  # Fix Qt build failure with GCC 4.1.
 set (patch_command PATCH_COMMAND
                    ${CMAKE_COMMAND} -E copy_if_different
                    ${SuperBuild_PROJECTS_DIR}/patches/qt4.src.3rdparty.webkit.Source.WebKit.pri
                    <SOURCE_DIR>/src/3rdparty/webkit/Source/WebKit.pri)
elseif (APPLE)
  # Set the platform to be clang if on apple and not gcc
  # This doesn't work on 10.5 (leopard) 10.6 (snow leopard) toolchain, however.
  # So, we check for that.
  if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND
      CMAKE_OSX_DEPLOYMENT_TARGET AND
      CMAKE_OSX_DEPLOYMENT_TARGET VERSION_GREATER "10.6")
    list (APPEND qt_options -platform unsupported/macx-clang)
  endif()

  list (APPEND qt_options
              -sdk ${CMAKE_OSX_SYSROOT}
              -arch ${CMAKE_OSX_ARCHITECTURES}
              -qt-libpng)
endif()
set(qt_EXTRA_CONFIGURATION_OPTIONS ""
    CACHE STRING "Extra arguments to be passed to Qt when configuring.")

# See https://bugreports.qt.io/browse/QTBUG-5774 and the links available there.
option(qt_WORK_AROUND_BROKEN_ASSISTANT_BUILD
  "Work around a build issue in Qt. Use this if you see linker errors with QtHelp and QCLucene." OFF)
mark_as_advanced(qt_WORK_AROUND_BROKEN_ASSISTANT_BUILD)

set(extra_commands)
if (qt_WORK_AROUND_BROKEN_ASSISTANT_BUILD)
  # This hack is required because Qt's build gets mucked up when we set
  # LDFLAGS, CXXFLAGS, etc. Installing things makes it work because the files
  # get placed into the install tree which has rpaths so they get found. Since
  # it is such a hack, it is an option which off and hidden by default.
  set (extra_commands
        BUILD_COMMAND make install
        INSTALL_COMMAND "")
elseif (CMAKE_GENERATOR STREQUAL "Ninja")
  # when using ninja, we can't use Ninja to build Qt, so we change that to
  # "make".
  set (extra_commands
        BUILD_COMMAND make
        INSTALL_COMMAND make install)
endif()
add_external_project_or_use_system(
    qt4
    DEPENDS zlib ${qt_depends}
    ${patch_command}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure
      -prefix <INSTALL_DIR>
      -confirm-license
      -no-audio-backend
      -no-dbus
      -no-declarative-debug
      -no-multimedia
      -nomake demos
      -nomake examples
      -nomake tests
      -no-multimedia
      -no-openssl
      -no-phonon
      -no-script
      -no-scripttools
      -no-svg
      -no-webkit
      -no-xinerama
      -no-xvideo
      -opensource
      -qt-libjpeg
      -qt-libtiff
      -release
      -system-zlib
      -xmlpatterns
      -I <INSTALL_DIR>/include
      -L <INSTALL_DIR>/lib
      ${qt_options}
      ${qt_EXTRA_CONFIGURATION_OPTIONS}
      ${extra_commands}
    BUILD_COMMAND make install
    INSTALL_COMMAND ""
)
unset(extra_commands)

if ((NOT 64bit_build) AND UNIX AND (NOT APPLE))
  # on 32-bit builds, we are incorrectly ending with QT_POINTER_SIZE chosen as
  # 8 (instead of 4) with GCC4.1 toolchain on old debians. This patch overcomes
  # that.
  add_external_project_step(qt4-patch-configure
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
                              ${SuperBuild_PROJECTS_DIR}/patches/qt4.configure
            <SOURCE_DIR>/configure
    DEPENDEES patch
    DEPENDERS configure)
endif()

if (APPLE)
  # corewlan .pro file needs to be patched to find
  add_external_project_step(qt4-patch-corewlan
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
                              ${SuperBuild_PROJECTS_DIR}/patches/qt4.src.plugins.bearer.corewlan.corewlan.pro
            <SOURCE_DIR>/src/plugins/bearer/corewlan/corewlan.pro
    DEPENDEES configure
    DEPENDERS build)

  # Patch for modal dialog errors on 10.9 and up
  # See https://bugreports.qt-project.org/browse/QTBUG-37699?focusedCommentId=251106#comment-251106
  add_external_project_step(qt4-patch-modal-dialogs
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
                              ${SuperBuild_PROJECTS_DIR}/patches/qt4.src.gui.kernel.qeventdispatcher_mac.mm
                              <SOURCE_DIR>/src/gui/kernel/qeventdispatcher_mac.mm
    DEPENDEES configure
    DEPENDERS build)
endif()

add_extra_cmake_args(
  -DPARAVIEW_QT_VERSION:STRING=4
)
