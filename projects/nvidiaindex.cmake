if (superbuild_build_phase AND "x${CMAKE_CXX_COMPILER_ID}" STREQUAL "xMSVC")
  if (MSVC_VERSION VERSION_LESS 1800 OR NOT MSVC_VERSION VERSION_LESS 2000)
    message(FATAL_ERROR
      "NVIDIA IndeX only provides libraries for MSVC 2013, MSVC 2015.")
  endif ()
endif ()

superbuild_add_project(nvidiaindex
  LICENSE_FILES
    "${CMAKE_CURRENT_LIST_DIR}/files/NVIDIA-Index-EULA.txt" # The package only provides a license in .pdf format
    README.txt
    license.txt
  SPDX_LICENSE_IDENTIFIER
    "LicenseRef-nvidiaindex AND Zlib AND BSD-3-Clause AND LGPL-2.1 AND FreeImage AND BSL-1.0 AND FTL AND OFL-1.1-RFN AND OpenSSL AND MIT AND CC-BY-4.0 AND Apache-2.0 AND BSD-2-Clause AND blessing"
  SPDX_COPYRIGHT_TEXT
    "Copyright 2021 NVIDIA Corporation" # README.txt
    "Copyright (C) 1995-2017 Jean-loup Gailly and Mark Adler" # zlib
    "Copyright (c) 2003-2008 University of Illinois at Urbana-Champaign" # LLVM
    "Copyright (C) 2003-2009 Adobe Systems Incorporated" # RTMP
    "Copyright (c) the FFmpeg developers" # recovered from ffmpeg common superbuild project
    "Copyright (c) the FreeImage contributors" # no copyright statement in the FreeImage license
    "Copyright (c) x264, LLC" # x264
    "© 2010-2011 Lucasfilm Entertainment Company Ltd. or Lucasfilm Ltd." # Alembic
    "© 2010-2011 Sony Pictures Imageworks Inc." # Alembic
    "Copyright Beman Dawes, David Abrahams, 1998-2005" # recovered from boost common superbuild project
    "Copyright Rene Rivera 2004-2007" # recovered from boost common superbuild project
    "copyright 2007. The FreeType Project" # Freetype
    "Copyright (c) 2012, Pablo Impallari" # Libre Baskerville font
    "Copyright (c) 2012, Rodrigo Fuenzalida" # Libre Baskerville font
    "Copyright 2010, 2012 Adobe Systems Incorporated" # Source Sans Pro font
    "Copyright (C) 1995-1998 Eric Young" # OpenSSL
    "Copyright (c) 2007-2010 Baptiste Lepilleur and The JsonCpp Authors" # Jsoncpp
    "Copyright (c) 2010 James Halliday" # browserify, recovered from https://github.com/browserify/browserify
    "Copyright (c) 2014 TJ Holowaychuk" # superagent
    "Copyright (c) 2014 Marc Harter" # humane.js
    "Copyright (c) Facebook, Inc. and its affiliates" # React
    "Copyright (c) 2015 Jed Watson" # React-Select
    "Copyright (c) 2011-2015 Tim Wood, Iskren Chernev, Moment.js contributors" # Moment-js
    "Copyright (c) 2015-present Ionic" # Ionicons, recovered from https://github.com/ionic-team/ionicons
    "Copyright Google LLC" # Material Design Icons, recovered from https://github.com/google/material-design-icons
    "Copyright (c) Intel Corporation" # from embree common superbuild project
    "Copyright (C) 2009-2016 Francesc Alted" # Blosc
    "Copyright (c) 2014 Kiyoshi Masui" # Bitshuffle
    "Copyright (C) 2005-2007 Ariya Hidayat" # FastLZ
    "Copyright (C) 2011-2014, Yann Collet" # LZ4
    "Copyright 2011, Google Inc" # Snappy
    "Copyright (c) 2014-2018 Omar Cornut" # ImGui
    "Copyright (c) 2004, 2005 Tristan Grimmer" # ProggyClean
    "Copyright jQuery Foundation and other contributors" # jQuery
    "Copyright (c) 2016 Claudio Holanda" # CodeFlask
    "Copyright (c) 2012 Lea Verou" # Prism, recovered from https://github.com/PrismJS/prism
    "Copyright (c) 2002 Cynthia Brewer, Mark Harrower, and The Pennsylvania State University" # ColorBrewer
    "Copyright (c) 2013-2019 Niels Lohmann" # llohmann json
    "Copyright 2015 Google Inc." # Roboto font, recovered from https://github.com/googlefonts/roboto
    "Copyright 2010-2017 Mike Bostock" # d3
    "Copyright (c) 2015 Espen Hovlandsdal" # React-markdown
    "Copyright Lee Thomason, Yves Berquin, Andrew Ellerton" # TinyXML
    "Copyright (C) 2008-2016, Nigel Stewart" # glew
    "Copyright (C) 2002-2008, Milan Ikits" # glew
    "Copyright (C) 2002-2008, Marcelo E. Magallon" # glew
    "Copyright (C) 2002, Lev Povalahev" # glew
    "Copyright (C) 1999-2020 Dieter Baron and Thomas Klausner" # libzip
    "Copyright (c) 2020, caddon color technology" # AIX
    "Copyright (c) 2004, Brian Hook" # POSH
    "Copyright (c) 2006 Simon Brown" # Squish
    "Copyright 2006 Mike Acton" # Half.cpp
    "Copyright (c) 2006 Simon Brown" # SimdVector
    "Copyright (c) 2006 Simon Brown" # Clusterfit
    "Copyright (c) 2006 Ignacio Castano" # Clusterfit
  SPDX_CUSTOM_LICENSE_FILE
    "${CMAKE_CURRENT_LIST_DIR}/files/NVIDIA-Index-EULA.txt"
  SPDX_CUSTOM_LICENSE_NAME
    LicenseRef-nvidiaindex
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dsource_dir:PATH=<SOURCE_DIR>
      -Dinstall_dir:PATH=<INSTALL_DIR>
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/nvidiaindex.install.cmake"
  INSTALL_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/scripts/nvidiaindex.install.cmake")
