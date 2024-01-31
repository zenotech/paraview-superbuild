# Make a project so that the user can enable/disable openxrremoting support
superbuild_add_project(openxrremoting
  LICENSE_FILES
    "<BINARY_DIR>/SDK Terms.txt"
    "Third Party Notices.txt"
  SPDX_LICENSE_IDENTIFIER
    "LicenseRef-openxrremoting AND BSL-1.0 AND BSD-2-Clause AND BSD-3-Clause AND LZMA-SDK-9.22 AND MIT AND JSON"
  SPDX_COPYRIGHT_TEXT
    "Copyright (C) Microsoft Corporation" # Recovered from a header
    "Copyright Beman Dawes, David Abrahams, 1998-2005" # Boost
    "Copyright Rene Rivera 2004-2007" # Boost
    "Copyright (c) 2010-2011 Xiph.Org Foundation, Skype Limited" # Opus
    "Copyright 2008 Google Inc." # Protobuf
    "Copyright (c) 2013-2020 The CivetWeb developers" # Civetweb
    "Copyright (c) 2004-2013 Sergey Lyubka" # Civetweb
    "Copyright (c) 2013 No Face Press, LLC (Thomas Davis)" # Civetweb
    "Copyright (c) 2013 F-Secure Corporation" # Civetweb
    "Copyright (C) 2015 THL A29 Limited, a Tencent company, and Milo Yip" # Rapidjson
    "Copyright (c) 2006-2013 Alexander Chemeris" # msinttypes
    "Copyright (c) 2002 JSON.org" # JSON
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    "${CMAKE_COMMAND}"
      -Dsource_location:PATH=<SOURCE_DIR>
      -Dbinary_location:PATH=<BINARY_DIR>
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/openxrremoting.build.cmake"
  BUILD_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/scripts/openxrremoting.build.cmake"
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dsource_location:PATH=<SOURCE_DIR>
      -Dinstall_location:PATH=<INSTALL_DIR>
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/openxrremoting.install.cmake"
  INSTALL_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/scripts/openxrremoting.install.cmake"
)
