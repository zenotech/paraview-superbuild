superbuild_add_project(gmsh
  LICENSE_FILES
    LICENSE.txt
  SPDX_LICENSE_IDENTIFIER
    GPL-3.0-interface-exception
  SPDX_COPYRIGHT_TEXT
    "Copyright (C) 1997-2022 C. Geuzaine, J.-F. Remacle"
  CMAKE_ARGS
    -DBUILD_TESTING:BOOL=OFF
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DENABLE_CAIRO:BOOL=OFF
    -DENABLE_FLTK:BOOL=OFF
    -DENABLE_ONELAB:BOOL=OFF
    -DENABLE_ONELAB_METAMODEL:BOOL=OFF
    -DENABLE_BUILD_SHARED:BOOL=${BUILD_SHARED_LIBS})

superbuild_apply_patch(gmsh stdint-includes "Missing stdint.h include")
superbuild_apply_patch(gmsh string-includes "Missing string.h include")
