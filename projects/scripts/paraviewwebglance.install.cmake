file(
  INSTALL ${source_location}/dist/
  DESTINATION "${install_location}/share/paraview/web/glance/www/"
  PATTERN "glance-external-*" EXCLUDE
  PATTERN "itk" EXCLUDE
  PATTERN "ParaViewGlance.html" EXCLUDE
)
file(
  INSTALL ${source_location}/dist/ParaViewGlance.html
  DESTINATION "${install_location}/share/paraview/web/glance"
)
