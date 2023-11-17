superbuild_add_project(visrtx
  DEPENDS nvidiamdl nvidiaoptix
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2019, NVIDIA CORPORATION"
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_MACOSX_RPATH:BOOL=FALSE
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DVISRTX_BUILD_SAMPLE:BOOL=OFF)

superbuild_apply_patch(visrtx cuda-11
  "Support CUDA 11")

superbuild_apply_patch(visrtx cuda-12
  "Support CUDA 12")
