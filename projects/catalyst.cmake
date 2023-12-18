set(catalyst_options)
if (UNIX AND NOT APPLE)
  list(APPEND catalyst_options
    -DCMAKE_INSTALL_RPATH:STRING=<INSTALL_DIR>/lib)
endif ()

superbuild_add_project(catalyst
  CAN_USE_SYSTEM
  DEPENDS
    cxx11
  DEPENDS_OPTIONAL
    mpi
    numpy
  LICENSE_FILES
    License.txt
    3rdPartyLicenses.txt
  SPDX_LICENSE_IDENTIFIER
    "BSD-3-Clause AND MIT AND JSON"
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2000-2005 Kitware Inc."
    "Copyright (c) 2014-2018, Lawrence Livermore National Security, LLC." # Conduit
    "Copyright (c) 2017-2019 Ingy döt Net" # libyaml
    "Copyright (c) 2006-2016 Kirill Simonov" # libyaml
    "Copyright (C) 2015 THL A29 Limited, a Tencent company, and Milo Yip" # Rapidjson
    "Copyright (c) 2006-2013 Alexander Chemeris" # msinttypes
    "Copyright (c) 2002 JSON.org" # JSON
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCATALYST_BUILD_TESTING:BOOL=OFF
    -DCATALYST_WRAP_PYTHON:BOOL=${numpy_enabled} # numpy is required by python wrappings on conduit
    -DCATALYST_WRAP_FORTRAN:BOOL=OFF
    -DCATALYST_USE_MPI:STRING=${mpi_enabled}
    ${catalyst_options})
