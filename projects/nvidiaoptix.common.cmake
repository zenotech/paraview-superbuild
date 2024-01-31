superbuild_add_project(nvidiaoptix
  LICENSE_FILES
    "${CMAKE_CURRENT_LIST_DIR}/files/NVIDIA-OptiX-SDK-6.0.0-EULA.txt" # The package only provides a license in .pdf format
    doc/OptiX_ThirdParty_Licenses.txt
  SPDX_LICENSE_IDENTIFIER
    "LicenseRef-nvidiaoptix AND MIT AND Spencer-94 AND Zlib AND LGPL-2.1-only AND FreeImage AND BSL-1.0 AND BSD-3-Clause AND Zlib AND BLESSING "
  SPDX_COPYRIGHT_TEXT
    "Copyright NVIDIA Corporation" # Extrapolated from source files
    "Copyright (c) 1988-1997 Sam Leffler" # Libtiff
    "Copyright (c) 1991-1997 Silicon Graphics, Inc." # Libtiff
    "Copyright 1992, 1993, 1994, 1997 Henry Spencer" # Regex
    "Copyright (C) 1995-2004 Jean-loup Gailly and Mark Adler" # Zlib
    "Copyright (c) 2015, NVIDIA CORPORATION" # ffmpeg according to their documentation
    "Copyright (c) the FreeImage contributors" # no copyright statement in the FreeImage license
    "Copyright Beman Dawes, David Abrahams, 1998-2005" # recovered from boost common superbuild project
    "Copyright Rene Rivera 2004-2007" # recovered from boost common superbuild project
    "Copyright (c) 2007-2010 Baptiste Lepilleur" # Jsoncpp
    "Copyright 2003-2005 Diego Nehab." # RPly
    "Copyright (c) 2003-2015 University of Illinois at Urbana-Champaign" # LLVM
    "Copyright (C) 2008-2016, Nigel Stewart" # glew
    "Copyright (C) 2002-2008, Milan Ikits" # glew
    "Copyright (C) 2002-2008, Marcelo E. Magallon" # glew
    "Copyright (C) 2002, Lev Povalahev" # glew
    "Copyright (c) 2006, Industrial Light & Magic, a division of Lucasfilm Entertainment Company Ltd." # OpenEXR
    "Copyright (c) 2005-2016 Lode Vandevenne" # PNG Reader
    "Copyright 1993-2015 NVIDIA Corporation" # CUDNN
    "Copyright (c) 2005, Google Inc." # Google Performance Tools
  SPDX_CUSTOM_LICENSE_FILE
    "${CMAKE_CURRENT_LIST_DIR}/files/NVIDIA-OptiX-SDK-6.0.0-EULA.txt"
  SPDX_CUSTOM_LICENSE_NAME
    LicenseRef-nvidiaoptix
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    ${CMAKE_COMMAND}
      -Dsource_location:PATH=<SOURCE_DIR>
      -Dinstall_location:PATH=<INSTALL_DIR>
      -Dlibdir:STRING=${nvidiaoptix_libdir}
      -Dlibsuffix:STRING=${nvidiaoptix_libsuffix}
      -Dlibdest:STRING=${nvidiaoptix_libdest}
      -Dbindir:STRING=${nvidiaoptix_bindir}
      -Dbinsuffix:STRING=${nvidiaoptix_binsuffix}
      -Dbindest:STRING=${nvidiaoptix_bindest}
      ${nvidiaoptix_install_args}
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/nvidiaoptix.install.cmake"
  INSTALL_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/scripts/nvidiaoptix.install.cmake")

superbuild_add_extra_cmake_args(
  -DOptiX_ROOT:PATH=<INSTALL_DIR>)

superbuild_apply_patch(nvidiaoptix cuda-12
  "Support CUDA 12")
