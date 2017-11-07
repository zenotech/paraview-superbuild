file(INSTALL
  ${source_location}/dist/
  DESTINATION "${install_location}/share/paraview/web/divvy/www")
file(INSTALL
  ${source_location}/Server/
  DESTINATION "${install_location}/share/paraview/web/divvy/server")
