superbuild_add_project(nvidiamdl
  LICENSE_FILES
    "${CMAKE_CURRENT_LIST_DIR}/files/NVIDIA-OptiX-SDK-6.0.0-EULA.txt" # The package only provide a license in .pdf format
    license.txt
  SPDX_LICENSE_IDENTIFIER
    "LicenseRef-nvidiaoptix AND BSD-3-Clause AND FreeImage AND LGPL-2.1-Only AND Libpng AND BSD-2-Clause AND IJG AND BSD-1.0 AND  	OFL-1.1-no-RFN AND OFL-1.1-RFN"
  SPDX_COPYRIGHT_TEXT
    "Copyright NVIDIA Corporation" # Extrapolated from source files
    "(C) 1995-2013 Jean-loup Gailly and Mark Adler" # ZLib
    "Copyright (c) 2003-2013 University of Illinois at Urbana-Champaign" # LLVM
    "Copyright (c) the FreeImage contributors" # no copyright statement in the FreeImage license
    "Copyright (c) 2006, Industrial Light & Magic, a division of Lucasfilm Entertainment Company Ltd." # ilm, OpenEXR
    "Copyright (c) 2010, Google Inc." # LibWebP
    "Copyright (C) 2008-2013 LibRaw LLC" # libRawLite
    "Copyright (c) 1995-2018 The PNG Reference Library Authors" # Extracted from libpng2 license
    "Copyright (c) 2018 Cosmin Truta" # Extracted from libpng2 license
    "Copyright (c) 2000-2002, 2004, 2006-2018 Glenn Randers-Pehrson" # Extracted from libpng2 license
    "Copyright (c) 1996-1997 Andreas Dilger" # Extracted from libpng2 license
    "Copyright (c) 1995-1996 Guy Eric Schalnat, Group 42, Inc" # Extracted from libpng2 license
    "Copyright (c) 2002-2012, Communications and Remote Sensing Laboratory, Universite catholique de Louvain (UCL), Belgium" # LibOpenJPEG
    "Copyright (c) 2002-2012, Professor Benoit Macq" # LibOpenJPEG
    "Copyright (c) 2003-2012, Antonin Descampe" # LibOpenJPEG
    "Copyright (c) 2003-2009, Francois-Olivier Devaux" # LibOpenJPEG
    "Copyright (c) 2005, Herve Drolon, FreeImage Team" # LibOpenJPEG
    "Copyright (c) 2002-2003, Yannick Verschueren" # LibOpenJPEG
    "Copyright (c) 2001-2003, David Janssens" # LibOpenJPEG
    "Copyright (c) 2011-2012, Centre National d'Etudes Spatiales (CNES), France" # LibOpenJPEG
    "Copyright (c) 2012, CS Systemes d'Information, France" # LibOpenJPEG
    "Copyright © 2013 Microsoft Corp." # LibJXR
    "copyright (C) 1991-2014, Thomas G. Lane, Guido Vollbeding" # LibJPEG
    "Copyright (c) 1988-1997 Sam Leffler" # LibTIFF4
    "Copyright (c) 1991-1997 Silicon Graphics, Inc." # LibTIFF4
    "Copyright Beman Dawes, David Abrahams, 1998-2005" # recovered from boost common superbuild project
    "Copyright Rene Rivera 2004-2007" # recovered from boost common superbuild project
    "Copyright (C) 1999-2018 Dieter Baron and Thomas Klausner" # Libzip
    "Copyright (c) 2012, Pablo Impallari" # Baskerville
    "Copyright (c) 2012, Rodrigo Fuenzalida" # Baskerville
    "Copyright 2010, 2012 Adobe Systems Incorporated" # Source Sans Pro
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
      -Dlibdir:STRING=${nvidiamdl_libdir}
      -Dlibsuffix:STRING=${CMAKE_SHARED_MODULE_SUFFIX}
      -Dlibdest:STRING=${nvidiamdl_libdest}
      ${nvidiamdl_install_args}
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/nvidiamdl.install.cmake"
  INSTALL_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/scripts/nvidiamdl.install.cmake")

superbuild_add_extra_cmake_args(
  -DMDL_INSTALL_DIR:PATH=<INSTALL_DIR>)
