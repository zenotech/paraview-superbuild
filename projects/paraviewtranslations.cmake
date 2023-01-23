superbuild_add_project(paraviewtranslations
  LICENSE_FILES
    LICENSE
  CMAKE_ARGS
    -DPROVIDE_QT_TRANSLATIONS:BOOL=ON
  DEPENDS
    qt5
)
