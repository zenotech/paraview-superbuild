file(INSTALL
  ${source_location}/dist/
  DESTINATION "${install_location}/share/paraview/web/flow/www")
file(INSTALL
  ${source_location}/server/
  DESTINATION "${install_location}/share/paraview/web/flow/server")
