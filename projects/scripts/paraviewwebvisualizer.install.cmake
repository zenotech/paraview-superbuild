file(INSTALL
  ${source_location}/dist/
  DESTINATION "${install_location}/share/paraview/www/visualizer")
file(INSTALL
  ${source_location}/server/pvw-visualizer.py
  DESTINATION "${install_location}/bin")
