set(_build_subdir <SOURCE_DIR>/MILI-build)

superbuild_add_project(mili
  CAN_USE_SYSTEM
  DEPENDS rapidjson # VisIt's Mili reader needs rapidjson
  LICENSE_FILES
    LICENSE.txt
  SPDX_LICENSE_IDENTIFIER
    LGPL-2.1-or-later
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2016, Lawrence Livermore National Security, LLC. Produced at the Lawrence Livermore National Laboratory"
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
  BUILD_COMMAND
    make -C ${_build_subdir} opt fortran=false
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
    -Dbuild_subdir=${_build_subdir}
    -Dinstall_location=<INSTALL_DIR>
    -P "${CMAKE_CURRENT_LIST_DIR}/scripts/mili.install.cmake"
  INSTALL_DEPENDS "${CMAKE_CURRENT_LIST_DIR}/scripts/mili.install.cmake"
)

superbuild_apply_patch(mili unix-patch1 "Mili Unix patch 1")
superbuild_apply_patch(mili xcode-12 "Mili errors from Xcode 12")
if (APPLE)
  # Patches derived from VisIt build
  # https://portal.nersc.gov/project/visit/releases/3.0.0/build_visit3_0_0
  superbuild_apply_patch(mili darwin-patch1 "Mili Darwin patch 1")
  superbuild_apply_patch(mili darwin-patch2 "Mili Darwin patch 2")
endif()
superbuild_apply_patch(mili darwin-patch3 "Mili Darwin patch 3")

superbuild_apply_patch(mili buildinfo-crash "Fix buildinfo crashes")

superbuild_add_extra_cmake_args(
  -DMili_INCLUDE_DIR:PATH=<INSTALL_DIR>/include/mili
  -DMili_LIBRARY:PATH=<INSTALL_DIR>/lib/libmili.a
)
