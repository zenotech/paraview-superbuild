file(INSTALL
  ${source_location}/dist/
  DESTINATION "${install_location}/share/paraview/web/glance/www")
file(INSTALL
  ${source_location}/dist/ParaViewGlance.html
  DESTINATION "${install_location}/share/paraview/web/glance/ParaViewGlance.html")
