if (superbuild_build_phase AND "x${CMAKE_CXX_COMPILER_ID}" STREQUAL "xMSVC")
  if (MSVC_VERSION VERSION_LESS 1800)
    message(FATAL_ERROR
      "NVIDIA IndeX requires MSVC 2013 or newer.")
  endif ()
endif ()

if (nvidiaindex_SOURCE_SELECTION VERSION_GREATER_EQUAL "5.12")
  set(nvidiaindex_eula_txt "EULA.txt")
else ()
  # The package only provides a license in .pdf format
  set(nvidiaindex_eula_txt "${CMAKE_CURRENT_LIST_DIR}/files/NVIDIA-Index-EULA.txt")
endif ()

superbuild_add_project(nvidiaindex
  LICENSE_FILES
    "${nvidiaindex_eula_txt}"
    README.txt
    license.txt
  SPDX_LICENSE_IDENTIFIER
    "LicenseRef-nvidiaindex AND blessing AND bzip2-1.0.6 AND Apache-2.0 AND BSD-2-Clause AND BSD-3-Clause AND BSL-1.0 AND FTL AND MIT AND MIT-Modern-Variant AND MPL-2.0 AND Zlib"
  SPDX_COPYRIGHT_TEXT
    "Copyright 2025 NVIDIA Corporation" # README.txt
    "Copyright (c) 2014 Kiyoshi Masui" # Bitshuffle
    "Copyright (C) 2009-2016 Francesc Alted" # Blosc
    "Copyright (C) 2019-present Blosc Development team" # Blosc
    "Copyright Beman Dawes, David Abrahams, 1998-2005" # recovered from boost common superbuild project
    "Copyright Rene Rivera 2004-2007" # recovered from boost common superbuild project
    "Copyright © 1996-2019 Julian Seward" # bzip2
    "Copyright (C) 2005-2007 Ariya Hidayat" # FastLZ
    "Copyright 1996-2024. The FreeType Project" # Freetype
    "Copyright © 2010-2022 Google, Inc." # harfbuzz
    "Copyright © 2015-2020 Ebrahim Byagowi" # harfbuzz
    "Copyright © 2019,2020 Facebook, Inc." # harfbuzz
    "Copyright © 2012,2015 Mozilla Foundation" # harfbuzz
    "Copyright © 2011 Codethink Limited" # harfbuzz
    "Copyright © 2008,2010 Nokia Corporation and/or its subsidiary(-ies)" # harfbuzz
    "Copyright © 2009 Keith Stribley" # harfbuzz
    "Copyright © 2011 Martin Hosken and SIL International" # harfbuzz
    "Copyright © 2007 Chris Wilson" # harfbuzz
    "Copyright © 2005,2006,2020,2021,2022,2023 Behdad Esfahbod" # harfbuzz
    "Copyright © 2004,2007,2008,2009,2010,2013,2021,2022,2023 Red Hat, Inc." # harfbuzz
    "Copyright © 1998-2005 David Turner and Werner Lemberg" # harfbuzz
    "Copyright © 2016 Igalia S.L." # harfbuzz
    "Copyright © 2022 Matthias Clasen" # harfbuzz
    "Copyright © 2018,2021 Khaled Hosny" # harfbuzz
    "Copyright © 2018,2019,2020 Adobe, Inc" # harfbuzz
    "Copyright © 2013-2015 Alexei Podtelezhnikov" # harfbuzz
    "Copyright (C) 2011-2014, Yann Collet" # LZ4
    "Copyright Contributors to the OpenVDB Project" # NanoVDB
    "Copyright 1995-2024 The OpenSSL Project Authors" # OpenSSL
    "Copyright (C) 2003-2009 Adobe Systems Incorporated" # RTMP
    "Copyright 2011, Google Inc" # Snappy
    # "The author disclaims copyright to this source code" # sqlite ("blessing")
    "Copyright (C) 1995-2023 Jean-loup Gailly and Mark Adler" # zlib
    "Copyright (c) 2016-present, Facebook, Inc" # zstd
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
