# Build OpenCascade Core Technology
# This is newer than the oce project (which is used by CGM).

# fontconfig only required on linux
set(occt_fontconfig_dep)
if (UNIX AND NOT APPLE)
  set(occt_fontconfig_dep fontconfig)
endif ()

superbuild_add_project(occt
  DEPENDS freetype ${occt_fontconfig_dep}
  DEPENDS_OPTIONAL cxx11
  LICENSE_FILES
    LICENSE_LGPL_21.txt
    OCCT_LGPL_EXCEPTION.txt
  CMAKE_ARGS
    -DCMAKE_INSTALL_RPATH:PATH=$ORIGIN/../lib
    -D3RDPARTY_FREETYPE_DIR:PATH=<INSTALL_DIR>
    -D3RDPARTY_Fontconfig_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
    # Do not build Draw or Visualization modules as they require tcl/tk.
    -DBUILD_MODULE_Draw:BOOL=FALSE
    -DBUILD_MODULE_Visualization:BOOL=FALSE
    # Do not build docs or examples:
    -DBUILD_DOC_Overview:BOOL=OFF
    -DBUILD_SAMPLES_QT:BOOL=OFF
    # Fix targets to know their installed directory
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    # Install only what is needed to the superbuild's install dir
    -DINSTALL_DIR:PATH=<INSTALL_DIR>
    # Install dlls to the bin dir - but non-release builds need help, below.
    -DINSTALL_DIR_BIN:PATH=bin
    -DINSTALL_SAMPLES:BOOL=OFF
    -DINSTALL_TCL:BOOL=OFF
    -DINSTALL_TEST_CASES:BOOL=OFF
    -DINSTALL_TK:BOOL=OFF
)

superbuild_apply_patch(occt find-fontconfig
  "Use the superbuild's fontconfig")

superbuild_apply_patch(occt no-xlibs
  "Disable requirement of unnecessary X libraries")

# TODO The occt build system moves dlls on windows, appending "i" for RelWithDebInfo,
# and "d" for Debug builds. Need a post-install step that moves those dlls to "bin".
