file(INSTALL
  ${source_location}/dist/
  DESTINATION "${install_location}/share/paraview/web/visualizer/www")
file(INSTALL
  ${source_location}/server/
  DESTINATION "${install_location}/share/paraview/web/visualizer/server")
