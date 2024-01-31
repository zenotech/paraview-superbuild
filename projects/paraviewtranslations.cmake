superbuild_add_project(paraviewtranslations
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    Apache-2.0
  SPDX_COPYRIGHT_TEXT
    "Copyright Kitware SAS"
  CMAKE_ARGS
    -DPROVIDE_QT_TRANSLATIONS:BOOL=ON
  DEPENDS
    qt5
)
